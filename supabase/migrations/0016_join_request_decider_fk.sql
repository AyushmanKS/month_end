alter table join_requests
  drop constraint if exists join_requests_decided_by_uid_fkey;
alter table join_requests
  add constraint join_requests_decided_by_uid_fkey
  foreign key (decided_by_uid) references users(id) on delete set null;
