function stamp() {
  const d = new Date()
  const two = n => String(n).padStart(2, '0')
  return d.getFullYear() + two(d.getMonth() + 1) + two(d.getDate()) +
    '-' + two(d.getHours()) + two(d.getMinutes()) + two(d.getSeconds())
}

// Goal: QP-01 restrictions are kept, anonymous rating needs login, and admin sees the same pizza/tool.
describe('QP-01 A custom pizza reaches the admin list', () => {
  it('follows all seven steps of QP-01', () => {
    const pizzaName = 'Lab Pizza ' + stamp()
    const observation = { pizzaName, cypressVersion: Cypress.version, recordedAt: new Date().toISOString() }

    // Step 1: open QuickPizza with fresh cookies (Cypress test isolation).
    cy.visit('https://quickpizza.grafana.com')
    cy.get('h1').should('have.text', 'Looking to break out of your pizza routine?')

    // Step 2: show all four advanced fields.
    cy.contains('label', 'Advanced').click()
    for (const label of ['Max Calories per Slice', 'Excluded tools', 'Must be vegetarian', 'Custom Pizza Name']) {
      cy.contains('label', label).should('be.visible')
    }

    // Step 3: fill the restrictions and verify their displayed values.
    cy.contains('label', 'Max Calories per Slice').siblings('input')
      .clear().type('600').should('have.value', '600')
    cy.get('select').select('Knife')
    cy.contains('option', 'Knife').should('be.selected')
    cy.get('#default-checkbox').check().should('be.checked')
    cy.get('input#pizza-name').clear().type(pizzaName).should('have.value', pizzaName)

    // Step 4: observe the real request; compare its response with the displayed pizza.
    cy.intercept('POST', '/api/pizza').as('pizza')
    cy.get('button[name="pizza-please"]').click()
    cy.wait('@pizza').then(({ request, response }) => {
      expect(response.statusCode).to.equal(200)
      expect(request.body.maxCaloriesPerSlice).to.equal(600)
      const { pizza, calories } = response.body
      Object.assign(observation, { tool: pizza.tool, calories, vegetarian: response.body.vegetarian })
      cy.contains('#recommendations p', 'Tool:').should('have.text', 'Tool: ' + pizza.tool)
      cy.contains('#recommendations p', 'Calories per slice:')
        .should('have.text', 'Calories per slice: ' + calories)
      cy.wrap(pizza.tool).as('tool')
    })
    cy.get('#recommendations').should('contain', 'Name: ' + pizzaName)
    cy.contains('#recommendations p', 'Tool:').should('not.contain', 'Knife')
    cy.contains('#recommendations p', 'Calories per slice:').invoke('text').then(text => {
      const calories = Number(text.replace('Calories per slice:', '').trim())
      expect(calories).to.be.a('number').and.to.be.at.least(0).and.to.be.at.most(600)
    })
    cy.screenshot('qp01-step4-recommendation')

    // Step 5: anonymous rating must be rejected.
    cy.get('button[name="rate-5"]').click()
    cy.get('#rate-result').should('have.text', 'Please log in first.')
    cy.screenshot('qp01-step5-login-needed')

    // Step 6: use the same browser and public demo admin account.
    cy.adminLogin('admin', 'admin')
    cy.contains('Latest pizza recommendations').should('be.visible')

    // Step 7: search the entire admin list and compare the tool with step 4.
    cy.get('@tool').then(tool => {
      cy.contains('li', pizzaName).should('contain', '(tool=' + tool + ',')
        .invoke('text').then(text => { observation.adminRow = text })
    })
    cy.screenshot('qp01-step7-admin-list')
    cy.then(() => cy.task('saveObservation', observation))
  })
})
