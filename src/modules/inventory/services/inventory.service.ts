import { stockMovementSchema, type StockMovementInput } from '../validations/inventory.schema';

export class InventoryService {
  async recordMovement(input: StockMovementInput): Promise<{ ok: true }> {
    const validated = stockMovementSchema.parse(input);
    // TODO: apply optimistic lock / consistency check and persist immutable ledger entry.
    void validated;
    return { ok: true };
  }
}
