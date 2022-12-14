// Checks the X-forwarded-for header.  It's not always present and not very reliable, but at least better than nothing.
jQuery.fn.extend({
    checkIsProxy : function(){
        var deferred = $.Deferred();
        $.ajax({
            type: 'POST',
            url:'http://www.google.com',
            data: formData,
            success: function(data, textStatus, request){
                 if(request.getResponseHeader('X-Forwarded-For') !== undefined)
                    deferred.resolve("Proxy detected");
            },
            error: function(){
                deferred.reject("error");
            }
           });
        return deferred.promise();
    }
});
