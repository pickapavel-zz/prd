

$(document).ready(function() {
    var $search = $('#search');
    var $result = $('#result');
    var $loanOne = $('#loanOne');
    var $companies = $('#companies');

    var $clientInfo = $('#clientInfo');
    var $loginTrigger = $('#loginTrigger');
    var $searchTrigger = $('#searchTrigger');
    var $editTrigger = $('#editTrigger');
    var $saveEditTrigger = $('#saveEditTrigger');
    var $cancelEditTrigger = $('#cancelEditTrigger');

    var $addCompanyTrigger = $('#addCompanyTrigger');
    var $addCompanyBlock = $('#addCompany');

    var $tableRowTrigger = $('.table-expand input[type="checkbox"]');

    function coinFlip() {
        return Math.floor(Math.random() * 2) === 0;
    }

    if($('#box-alert-error').length) {
        var test = coinFlip();
        if(test === true) {
            $('#allowLoan').html('Neni možné požičať').parent().removeClass('color-green').addClass('color-red');
            openAlertBox('#box-alert-error');
        }
    }

    // Prvky pro loading
    var getCurrentForm = function($el) {
        return $el.parents('form');
    };

    var toggleInputsEditation = function($form, allow) {
        if(allow) {
            $form.find('input[readonly]').each(function() {
                $(this).parent().find('.fa').hide();
                $(this).attr('readonly', false);
            });

            $form.find('input')[0].focus();
        } else {
            $form.find('input').each(function() {
                $(this).parent().find('.fa').show();
                $(this).attr('readonly', true);
            });
        }
    };

    var updateLs = function(inputs) {
        $.each(inputs, function(k, v) {
            client.set(k, v);
        });
    };

    $tableRowTrigger.on('change', function() {
        $(this).parent().find('.fa').toggleClass('is-rotated');

        $(this).parents('tr').next('tr').find('.table-detail').slideToggle();
    });


    $loginTrigger.on('click', function(e) {
        e.preventDefault();
    });

    $searchTrigger.on('click', function(e) {
        e.preventDefault();
    });

    $editTrigger.on('click', function(e) {
        e.preventDefault();

        $form = getCurrentForm($(this));
        toggleInputsEditation($form, true);

        $editTrigger.hide();
        $saveEditTrigger.show();
        $cancelEditTrigger.show();
    });

    $cancelEditTrigger.on('click', function(e) {
        e.preventDefault();

        $form = getCurrentForm($(this));
        toggleInputsEditation($form, false);

        // $saveEditTrigger.hide();
        $cancelEditTrigger.hide();
        $editTrigger.show();

    });

    $saveEditTrigger.on('click', function(e) {
        e.preventDefault();

        $form = getCurrentForm($(this));
        openModalLoading('Ukladám zmeny do systému');
        // toggleInputsEditation($form, false);

        var inputs = {};

        $form.find('input').each(function(i) {
            inputs[$(this).attr('id')] = $(this).val();
        });

        updateLs(inputs);

        // $saveEditTrigger.hide();
        $cancelEditTrigger.hide();
        // $editTrigger.show();
    });

    var $validatedBlock, numbersLength, $validatedMessage, limit;
    limit = 10;

    $("#client").on("change paste keyup", function() {
        $validatedBlock = $(this).parent('.form-group');
        $validatedMessage = $validatedBlock.find('.help-block');
        numbersLength = $(this).val().length;

        // Always remove style Classes for box -> then add desired class
        $validatedBlock.removeClass('has-warning has-error');

        if(numbersLength > 8 && numbersLength <= 10) {
            $validatedBlock.addClass('has-warning');
            $validatedMessage.text('Vyhľadávanie podľa RČ').show();
        } else if(numbersLength > 10) {
            $validatedBlock.addClass('has-error');
            $validatedMessage.text('Maximálny počet číslic je 10').show();

            $(this).val($(this).val().substr(0,limit));

            setTimeout(function() {
                $validatedBlock.removeClass('has-warning has-error');
                $validatedBlock.addClass('has-warning');
                $validatedMessage.text('Vyhľadávanie podľa RČ').show();
            }, 1500);

        } else if(numbersLength < 6){
            $validatedBlock.addClass('has-error');
            $validatedMessage.text('Minimálny počet číslic je 6').show();
        } else if(numbersLength <= 8) {
            $validatedBlock.addClass('has-warning');
            $validatedMessage.text('Vyhľadávanie podľa IČ').show();
        }
    });
});
