import express from 'express'
import dotenv from 'dotenv'
import cors from 'cors'

import authRoutes from './routes/auth.js'
import productRoutes from './routes/products.js'
import orderRoutes from './routes/orders.js'

dotenv.config()
const app = express()

app.use(cors())
app.use(express.json())

app.use('/api/auth', authRoutes)
app.use('/api/products', productRoutes)
app.use('/api/orders', orderRoutes)

const PORT = process.env.PROXY_PORT || 4000

app.listen(PORT, () => {
  console.log(`🔐 Proxy API running on http://localhost:${PORT}`)
})
