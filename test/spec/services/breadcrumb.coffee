describe 'Service: Breadcrumb', ->
  beforeEach module 'fgvApp'

  it 'should have a breadcrumb service', inject (breadcrumb) ->
    expect(breadcrumb).toNotBe null

  it 'should be able to add and get cuts', inject (openspending, breadcrumb) ->
    cut =
      type: 'funcao'
      id: 10
      label: 'SAUDE'
    spyOn(openspending, 'aggregate')
    breadcrumb.add(cut)
    cuts = breadcrumb.get()
    expect(cuts.length).toBe 1
    expect(cuts).toContain cut
    expect(openspending.aggregate).not.toHaveBeenCalled()

  it 'should get the added cut\'s labels if they don\'t have one', inject (openspending, breadcrumb) ->
    cuts = [
      { type: 'funcao', id: 10 }
      { type: 'subfuncao', id: 301 }
    ]
    labels = ['SAUDE', 'ATENCAO BASICA']
    response =
      data:
        drilldown: [
          funcao: { label: labels[0] },
          subfuncao: { label: labels[1] }
        ]
    promise = then: (callback) -> callback(response)
    spyOn(openspending, 'aggregate').andReturn(promise)
    breadcrumb.add(cuts)
    cuts = breadcrumb.get()
    expect(cuts.length).toEqual 2
    expect(cuts[0].label).toEqual labels[0]
    expect(cuts[1].label).toEqual labels[1]

  it 'should allow popping cuts', inject (breadcrumb) ->
    cut =
      type: 'funcao'
      id: 10
      label: 'SAUDE'
    breadcrumb.add(cut)
    expect(breadcrumb.pop()).toEqual cut
    expect(breadcrumb.get().length).toEqual 0

  it 'should allow peeking cuts', inject (breadcrumb) ->
    cut =
      type: 'funcao'
      id: 10
      label: 'SAUDE'
    breadcrumb.add(cut)
    expect(breadcrumb.peek()).toEqual cut
    expect(breadcrumb.get().length).toEqual 1
