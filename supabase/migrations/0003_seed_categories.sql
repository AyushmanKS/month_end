-- Seed the global preset categories once. Icon keys match categoryIcons in the app.

insert into categories (name, icon, is_preset) values
  ('Groceries', 'groceries', true),
  ('Bus', 'bus', true),
  ('E-Rickshaw', 'erickshaw', true),
  ('Auto', 'auto', true),
  ('Food', 'food', true),
  ('Rent', 'rent', true),
  ('Utilities', 'utilities', true),
  ('Shopping', 'shopping', true),
  ('Entertainment', 'entertainment', true),
  ('Other', 'other', true)
on conflict do nothing;
