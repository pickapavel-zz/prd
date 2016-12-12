client = Storages.initNamespaceStorage('client_secretary').localStorage;

if(client.isEmpty()) {
    client.set('name', 'Karel Kopfrkingl');
    client.set('pid', '800921/0021');
    client.set('birth-date', '1. 1. 1968');

    client.set('country', 'SR');
    client.set('city', 'Bratislava');
    client.set('street', 'Černyševského 3761/46');
    client.set('pid', '851 01');

    client.set('email', 'karel.kopfrkingl@test.com');
    client.set('phone', '+420775160190');

    client.set('id-type', 'Pas');
    client.set('id-number', 'TEST456789IU');
    client.set('id-from', '10.10.2010');
    client.set('id-to', '10.10.2020');
}
