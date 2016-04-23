# See https://github.com/voltrb/volt#routes for more info on routes

client '/users', component: 'admin', controller: 'main', action: 'users'
client '/marketing', component: 'admin', controller: 'main', action: 'index'
client '/users/{{ id }}', component: 'admin', controller: 'main', action: 'user'
