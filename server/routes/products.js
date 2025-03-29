import express from 'express'
import { wooClient } from '../utils/woo.js'
import { verifyToken } from '../middleware/auth.js'

const router = express.Router()

router.get('/', verifyToken, async (req, res) => {
  try {
    const { data } = await wooClient.get('/products')
    res.json(data)
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch products' })
  }
})

export default router
