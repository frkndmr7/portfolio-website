function handler(event) {
    var request = event.request;
    var host = request.headers.host && request.headers.host.value;

    if (host !== 'www.halilfurkandamar.com') {
        return request;
    }

    var location = 'https://halilfurkandamar.com' + request.uri;
    var querystring = request.querystring || {};
    var query = [];

    for (var key in querystring) {
        if (!Object.prototype.hasOwnProperty.call(querystring, key)) {
            continue;
        }

        var parameter = querystring[key];
        if (parameter.multiValue) {
            for (var i = 0; i < parameter.multiValue.length; i++) {
                query.push(key + '=' + parameter.multiValue[i].value);
            }
        } else if (parameter.value !== undefined) {
            query.push(key + '=' + parameter.value);
        } else {
            query.push(key);
        }
    }

    if (query.length > 0) {
        location += '?' + query.join('&');
    }

    return {
        statusCode: 308,
        statusDescription: 'Permanent Redirect',
        headers: {
            location: { value: location }
        }
    };
}
