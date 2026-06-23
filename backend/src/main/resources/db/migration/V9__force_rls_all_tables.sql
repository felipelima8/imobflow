-- V9__force_rls_all_tables.sql
-- Force Row Level Security on all tables so that policy rules are evaluated even for the table owner/connection user.
ALTER TABLE users FORCE ROW LEVEL SECURITY;
ALTER TABLE customers FORCE ROW LEVEL SECURITY;
ALTER TABLE properties FORCE ROW LEVEL SECURITY;
ALTER TABLE journeys FORCE ROW LEVEL SECURITY;
ALTER TABLE financing_simulations FORCE ROW LEVEL SECURITY;
ALTER TABLE notifications FORCE ROW LEVEL SECURITY;
ALTER TABLE audit_logs FORCE ROW LEVEL SECURITY;
ALTER TABLE subscriptions FORCE ROW LEVEL SECURITY;
