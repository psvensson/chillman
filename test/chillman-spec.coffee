expect    = require("chai").expect
Tiler     = require('../lib/Chillman')
defer     = require('node-promise').defer

debug = process.env['DEBUG']

describe "Chillman test", ()->


  before (done)->
    done()

  #-----------------------------------------------------------------------------------------------------------------------

  it "should work", (done)->
    expect(true).to.equal(true)
    done()