expect    = require("chai").expect
Chillman  = require('../lib/Chillman')
defer     = require('node-promise').defer

debug = process.env['DEBUG']

describe "Chillman test", ()->


  before (done)->
    done()

  #-----------------------------------------------------------------------------------------------------------------------

  it "should pause a second request before the first is completed and have both return same value", (done)->
    scarcecounter = 0
    scarceResource = (key)->
      q = defer()
      setTimeout(
        ()->
          rv = key+'_'+(scarcecounter++)
          #console.log 'scarceResource called. rv = '+rv
          q.resolve(rv)
        ,50
      )
      q

    count = 0
    results = []

    landing = (result)->
      results.push result
      if ++count == 2
        expect(results[0]).to.equal(results[1])
        #console.dir results
        done()

    Chillman.lookup(11, 'foo', scarceResource).then landing
    Chillman.lookup(11, 'foo', scarceResource).then landing

  it "should make sure that requests of different types are kept separate, even if done close together", (done)->
    scarceResource = (key, type)->
      q = defer()
      setTimeout(
        ()->
          rv = type+'_'+key
          #console.log 'scarceResource2 called. rv = '+rv
          q.resolve(rv)
      ,50
      )
      q

    count = 0
    results = []

    landing = (result)->
      results.push result
      if ++count == 2
        expect(results[0].indexOf('bar')).to.equal(-1)
        expect(results[1].indexOf('foo')).to.equal(-1)
        #console.dir results
        done()

    Chillman.lookup(11, 'foo', scarceResource).then landing
    Chillman.lookup(19, 'bar', scarceResource).then landing

