# See https://github.com/voltrb/volt#routes for more info on routes

client '/survey', component: 'survey', controller: 'main', action: 'index'
# client '/results', component: 'survey', controller: 'main', action: 'results'
client '/results/{{ id }}', component: 'survey', controller: 'main', action: 'results'
