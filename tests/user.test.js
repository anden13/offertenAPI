import request from 'supertest'
import app from '../src/index.js'
import prisma from '../src/lib/prisma.js'

describe('User API tests', () => {
  let companyId
  let user1Id
  let user2Id

  const uniqueSuffix = Date.now()
  const email1 = `user1_${uniqueSuffix}@test.com`
  const email2 = `user2_${uniqueSuffix}@test.com`

  beforeAll(async () => {
    const company = await prisma.company.create({
      data: {
        name: `Test Company ${uniqueSuffix}`
      }
    })

    console.log('Created company:', company)

    companyId = company.id
  })

  test('should create user 1', async () => {
    console.log('Using companyId for user 1:', companyId)

    const response = await request(app)
      .post('/users')
      .send({
        companyId,
        email: email1,
        firstName: 'User',
        lastName: 'One',
        phone: '111111111',
        role: 'TECHNICIAN',
        isActive: true
      })

    console.log('Create user 1 response:', response.body)

    expect(response.statusCode).toBe(201)
    user1Id = response.body.id
  })

  test('should create user 2', async () => {
    console.log('Using companyId for user 2:', companyId)

    const response = await request(app)
      .post('/users')
      .send({
        companyId,
        email: email2,
        firstName: 'User',
        lastName: 'Two',
        phone: '222222222',
        role: 'ADMIN',
        isActive: true
      })

    console.log('Create user 2 response:', response.body)

    expect(response.statusCode).toBe(201)
    user2Id = response.body.id
  })

  test('should fetch one user', async () => {
    const response = await request(app).get(`/users/${user1Id}`)

    console.log('Fetched user 1:', response.body)

    expect(response.statusCode).toBe(200)
    expect(response.body.id).toBe(user1Id)
  })

  test('should fetch all users', async () => {
    const response = await request(app).get('/users')

    console.log('All users:', response.body)

    expect(response.statusCode).toBe(200)
    expect(Array.isArray(response.body)).toBe(true)
  })

  afterAll(async () => {
    await prisma.$disconnect()
  })
})