# Ngrx Notes

## CRUD Actions

Suppose we're creating a Pie Management system, PieManHq.com.

```typescript
import { Action } from '@ngrx/store';
import { Pie } from '../../models/pie.model';

export const PIE_LOAD           = '[PIE] load';
export const PIE_LOAD_SUCCESS   = '[PIE] load success';
export const PIE_LOAD_FAIL      = '[PIE] load fail';
export const PIE_GET            = '[PIE] get';
export const PIE_GET_SUCCESS    = '[PIE] get success';
export const PIE_GET_FAIL       = '[PIE] get fail';
export const PIE_CREATE         = '[PIE] create';
export const PIE_CREATE_SUCCESS = '[PIE] create success';
export const PIE_CREATE_FAIL    = '[PIE] create fail';
export const PIE_UPDATE         = '[PIE] update';
export const PIE_UPDATE_SUCCESS = '[PIE] update success';
export const PIE_UPDATE_FAIL    = '[PIE] update fail';
export const PIE_REMOVE         = '[PIE] remove';
export const PIE_REMOVE_SUCCESS = '[PIE] remove success';
export const PIE_REMOVE_FAIL    = '[PIE] remove fail';
```
