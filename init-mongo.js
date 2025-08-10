db = db.getSiblingDB('reward-service-db');

db.createUser({
  user: 'reward-service-db-user',
  pwd: 'dbinitPASSWORD001axi00',
  roles: [{ role: 'readWrite', db: 'reward-service-db' }]
});
