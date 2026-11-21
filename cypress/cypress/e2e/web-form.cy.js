// Goal: fill the web form's field types and verify successful submission.
describe('Selenium web form', () => {
  it('fills in the form and verifies the submitted page', () => {
    cy.visit('https://www.selenium.dev/selenium/web/web-form.html')
    cy.title().should('eq', 'Web form')
    cy.get('#my-text-id').type('Cypress').should('have.value', 'Cypress')
    cy.get('[name="my-password"]').type('Secret123', { log: false })
    cy.get('[name="my-textarea"]').type('My first form test')
    cy.get('[name="my-select"]').select('Two').should('have.value', '2')
    cy.get('#my-check-2').check().should('be.checked')
    cy.get('#my-radio-2').check().should('be.checked')
    cy.get('[name="my-date"]').type('11/05/2026{esc}').should('have.value', '11/05/2026')
    cy.get('button[type="submit"]').click()
    cy.title().should('eq', 'Web form - target page')
    cy.get('#message').should('have.text', 'Received!')
  })
})
