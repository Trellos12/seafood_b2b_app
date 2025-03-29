import express from 'express'
import { wooClient } from '../utils/woo.js'
import { verifyToken } from '../middleware/auth.js'

const router = express.Router()

router.post('/', verifyToken, async (req, res) => {
  try {
    const order = req.body
    const { data } = await wooClient.post('/orders', order)
    res.json(data)
  } catch (err) {
    res.status(500).json({ error: 'Failed to create order' })
  }
})

export default router
