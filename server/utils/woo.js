import axios from 'axios'

export const wooClient = axios.create({
  baseURL: process.env.WOO_BASE_URL,
  auth: {
    username: process.env.WOO_CONSUMER_KEY,
    password: process.env.WOO_CONSUMER_SECRET
  }
})
