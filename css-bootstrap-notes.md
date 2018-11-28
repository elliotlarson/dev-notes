# Bootstrap notes

## Haml partial to view current grid size

Add this to your haml layout to view the current grid layout size:

```haml
%div{ style: 'z-index: 1000; position: absolute; width: 100%;' }
  .d-none.d-xl-block{ style: 'background: #007bff; color: #fff; padding: 5px; text-align: center;' } XL
  .d-none.d-lg-block.d-xl-none{ style: "background: #27a745; color: #fff; padding: 5px; text-align: center;" } LG
  .d-none.d-md-block.d-lg-none{ style: "background: #ffc108; color: #fff; padding: 5px; text-align: center;" } MD
  .d-none.d-sm-block.d-md-none{ style: "background: #18a2b8; color: #fff; padding: 5px; text-align: center;" } SM
  .d-block.d-sm-none{ style: "background: #dc3545; color: #fff; padding: 5px; text-align: center;" } XS
```
