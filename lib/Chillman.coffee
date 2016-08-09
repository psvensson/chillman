defer           = require('node-promise').defer
lru             = require('lru')

class Chillman

  @underwayCache: new lru()
  @callbackCache: new lru()

  @lookup: (key, type, resolveFunc) =>
    q = defer()
    underway = Chillman.underwayCache.get(key+'_'+type)
    if underway
      callbacks = Chillman.callbackCache.get(key+'_'+type) or []
      callbacks.push q
      Chillman.callbackCache.set(key+'_'+type, callbacks)
    else
      Chillman.underwayCache.set(key+'_'+type, true)
      Chillman._doLookup(key, type, resolveFunc, q)
    q

  @_doLookup: (key, type, resolveFunc, q) =>
    resolveFunc(key, type).then (result) =>
      Chillman.underwayCache.remove(key+'_'+type)
      callbacks = Chillman.callbackCache.get(key+'_'+type) or []
      cbcount = callbacks.length
      callbacks.forEach (_q) =>
        #console.log 'calling callback '+cbcount+' for '+key+' and '+type
        _q.resolve(result)
        if --cbcount == 0
          #console.log 'removing callback cache entry for '+key+'_'+type
          Chillman.callbackCache.remove(key+'_'+type)
      q.resolve(result)

module.exports = Chillman