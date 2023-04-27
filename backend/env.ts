import { config } from './deps.ts';

const env = config();

export const PINATA_API_KEY = env.PINATA_API_KEY;
export const PINATA_SECRET_KEY = env.PINATA_SECRET_KEY;
export const BLOCKFROST_PROJ = env.BLOCKFROST_PROJ;
export const MNEMONIC = env.MNEMONIC;
export const PORT = env.PORT;