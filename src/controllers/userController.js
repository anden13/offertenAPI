import prisma from '../lib/prisma.js'

export const createUser = async (req, res) => {
  try {
    const {
      companyId,
      email,
      firstName,
      lastName,
      phone,
      role,
      isActive
    } = req.body

    const user = await prisma.user.create({
      data: {
        companyId,
        email,
        firstName,
        lastName,
        phone,
        ...(role !== undefined && { role }),
        ...(isActive !== undefined && { isActive })
      }
    })

    res.status(201).json(user)
  } catch (error) {
    console.error('Error creating user:', error)
    res.status(500).json({ error: error.message })
  }
}

export const getUsers = async (req, res) => {
  try {
    const users = await prisma.user.findMany({
      include: {
        company: true,
        offers: true
      }
    })

    res.status(200).json(users)
  } catch (error) {
    console.error('Error fetching users:', error)
    res.status(500).json({ error: error.message })
  }
}

export const getUserById = async (req, res) => {
  try {
    const { id } = req.params

    const user = await prisma.user.findUnique({
      where: { id: Number(id) },
      include: {
        company: true,
        offers: true
      }
    })

    if (!user) {
      return res.status(404).json({ error: 'User not found' })
    }

    res.status(200).json(user)
  } catch (error) {
    console.error('Error fetching user:', error)
    res.status(500).json({ error: error.message })
  }
}

export const updateUser = async (req, res) => {
  try {
    const { id } = req.params
    const {
      email,
      firstName,
      lastName,
      phone,
      role,
      isActive
    } = req.body

    const user = await prisma.user.update({
      where: { id: Number(id) },
      data: {
        email,
        firstName,
        lastName,
        phone,
        role,
        isActive
      }
    })

    res.status(200).json(user)
  } catch (error) {
    console.error('Error updating user:', error)
    res.status(500).json({ error: error.message })
  }
}

export const deleteUser = async (req, res) => {
  try {
    const { id } = req.params

    await prisma.user.delete({
      where: { id: Number(id) }
    })

    res.status(200).json({ message: 'User deleted successfully' })
  } catch (error) {
    console.error('Error deleting user:', error)
    res.status(500).json({ error: error.message })
  }
}