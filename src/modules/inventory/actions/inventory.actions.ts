'use server';

import { requireSession } from '@/lib/auth';
import { InventoryService } from '../services/inventory.service';
import type { StockMovementInput } from '../validations/inventory.schema';

const service = new InventoryService();

export async function createStockMovement(input: StockMovementInput): Promise<{ ok: true }> {
  await requireSession();
  return service.recordMovement(input);
}
