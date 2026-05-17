import { z } from 'zod';

export const stockMovementSchema = z.object({
  movementType: z.enum(['IN', 'OUT', 'ADJUSTMENT', 'TRANSFER']),
  productId: z.string().uuid().optional(),
  materialId: z.string().uuid().optional(),
  warehouseLocationId: z.string().uuid(),
  batchNo: z.string().max(80).optional(),
  qty: z.number().positive(),
  referenceNo: z.string().max(120).optional(),
  notes: z.string().max(1000).optional(),
}).refine((v) => Boolean(v.productId) !== Boolean(v.materialId), {
  message: 'Exactly one of productId or materialId must be provided.',
});

export type StockMovementInput = z.infer<typeof stockMovementSchema>;
