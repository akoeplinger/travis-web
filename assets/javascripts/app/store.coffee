require 'store/rest_adapter'

Travis.Store = DS.Store.extend
  revision: 4
  adapter: Travis.RestAdapter.create()

  receive: (name, data) ->
    mappings = @adapter.get('mappings')
    type = mappings[name]

    if data[type.singularName()]
      @_loadOne(this, type, data)
    else if data[type.pluralName()]
      @_loadMany(this, type, data)
    else
      throw "can't load data for #{name}" unless type

  _loadOne: (store, type, json) ->
    root = type.singularName()
    @adapter.sideload(store, type, json, root)
    type.load(json[root])
    @_updateAssociations(type, name, json[root])

  _loadMany: (store, type, json) ->
    root = type.pluralName()
    @adapter.sideload(store, type, json, root)
    @loadMany(type, json[root])

  # _updateAssociations: (type, name, data) ->
  #   Em.get(type, 'associationsByName').forEach (key, meta) =>
  #     if meta.kind == 'belongsTo' && id = data["#{key}_id"]
  #       parent = type.find(data.id).get("#{key}.data")
  #       ids = parent.get("data.#{name}_ids")
  #       parent.set("data.#{name}_ids", ids.concat(data.id)) # if ids && !(data.id in ids)

  # _updateAssociations: (type, name, data) ->
  #   Em.get(type, 'associationsByName').forEach (key, meta) =>
  #     console.log [type, meta.type, meta.kind, meta.kind == 'belongsTo']
  #     if meta.kind == 'belongsTo'
  #       id = data["#{key}_id"]
  #       if clientId = @typeMapFor(meta.type).idToCid[id]
  #         if parent = this.findByClientId(meta.type, clientId, id)
  #           data = parent.get('data')
  #           if ids = data.get("#{name}_ids")
  #             ids.pushObject(data.id) unless data.id in ids
  #             parent.send('didChangeData');

  # _updateAssociations: (type, name, data) ->
  #   clientId = @typeMapFor(Travis.Repository).idToCid[data['repository_id']]

  #   associations = Em.get(type, 'associationsByName')
  #     console.log [type, meta.type, meta.kind, meta.kind == 'belongsTo']
  #     if meta.kind == 'belongsTo'
  #       id = data["#{key}_id"]
  #         if parent = this.findByClientId(meta.type, clientId, id)
  #           data = parent.get('data')
  #           if ids = data.get("#{name}_ids")
  #             ids.pushObject(data.id) unless data.id in ids
  #             parent.send('didChangeData')