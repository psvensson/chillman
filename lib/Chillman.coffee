defer           = require('node-promise').defer
lru             = require('lru')

class Chillman

  @underwayCache: new lru()
  @callbackCache: new lru()

  lookup: (key, resolveFunc) =>
    q = defer()
    underway = Chillman.underwayCache.get(key)
    if underway
      callbacks = Chillman.callbackCache[key] or []
      callbacks.push ()-> q
    else
      Chillman.underwayCache.set(key, true)
      _doLookup(key, resolveFunc, q)
    q

  _doLookup: (key, resolveFunc, q) =>
    resolveFunc(key).then (result) =>
      Chillman.underwayCache.remove(key)
      q.resolve(result)
      callbacks = Chillman.callbackCache[key] or []
      callbacks.forEach (_q) => _q.resolve(result)


module.exports = Chillman