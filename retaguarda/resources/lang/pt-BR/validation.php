<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Validation Language Lines
    |--------------------------------------------------------------------------
    |
    | The following language lines contain the default error messages used by
    | the validator class. Some of these rules have multiple versions such
    | such as the size rules. Feel free to tweak each of these messages.
    |
    */
    "alpha_spaces"     => "Só são permitidas letras",
    "accepted"         => "O campo :attribute deve ser aceito.",
    "active_url"       => "O campo :attribute não contém um URL válido.",
    "after"            => "O campo :attribute deverá conter uma data posterior a :date.",
    "alpha"            => "O campo :attribute deverá conter apenas letras.",
    "alpha_dash"       => "O campo :attribute deverá conter apenas letras, números e traços.",
    "alpha_num"        => "O campo :attribute deverá conter apenas letras e números .",
    "array"            => "O campo :attribute precisa ser um conjunto.",
    "before"           => "O campo :attribute deverá conter uma data anterior a :date.",
    "between"          => [
        "numeric" => "O campo :attribute deverá ter um valor entre :min - :max.",
        "file"    => "O campo :attribute deverá ter um tamanho entre :min - :max kilobytes.",
        "string"  => "O campo :attribute deverá conter entre :min - :max caracteres.",
        "array"   => "O campo :attribute precisar ter entre :min - :max itens.",
    ],
    "boolean"          => "O campo :attribute deverá ter o valor verdadeiro ou falso.",
    "confirmed"        => "A confirmação para o campo :attribute não coincide.",
    "date"             => "O campo :attribute não contém uma data válida.",
    "date_format"      => "A data indicada para o campo :attribute não respeita o formato :format.",
    "different"        => "Os campos :attribute e :other deverão conter valores diferentes.",
    "digits"           => "O campo :attribute deverá conter :digits dígitos.",
    "digits_between"   => "O campo :attribute deverá conter entre :min a :max dígitos.",
    "email"            => "O campo :attribute não contém um endereço de email válido.",
    "exists"           => "O valor selecionado para o campo :attribute é inválido.",
    "filled"           => "O campo :attribute é obrigatório.",
    "image"            => "O campo :attribute deverá conter uma imagem.",
    "in"               => "O campo :attribute não contém um valor válido.",
    "integer"          => "O campo :attribute deverá conter um número inteiro.",
    "ip"               => "O campo :attribute deverá conter um IP válido.",
    'json'             => 'O campo :attribute deverá conter uma string JSON válida.',
    "max"              => [
        "numeric" => "O campo :attribute não deverá conter um valor superior a :max.",
        "file"    => "O campo :attribute não deverá ter um tamanho superior a :max kilobytes.",
        "string"  => "O campo :attribute não deverá conter mais de :max caracteres.",
        "array"   => "O campo :attribute deve ter no máximo :max itens.",
    ],
    "mimes"            => "O campo :attribute deverá conter um arquivo do tipo: :values.",
    "min"              => [
        "numeric" => "O campo :attribute deverá ter um valor superior ou igual a :min.",
        "file"    => "O campo :attribute deverá ter no mínimo :min kilobytes.",
        "string"  => "O campo :attribute deverá conter no mínimo :min caracteres.",
        "array"   => "O campo :attribute deve ter no mínimo :min itens.",
    ],
    "not_in"           => "O campo :attribute contém um valor inválido.",
    "numeric"          => "O campo :attribute deverá conter um valor numérico.",
    "regex"            => "O formato do valor para o campo :attribute é inválido.",
    "required"         => "O campo :attribute é obrigatório.",
    "required_if"      => "O campo :attribute é obrigatório quando o valor do campo :other é igual a :value.",
    "required_with"    => "O campo :attribute é obrigatório quando :values está presente.",
    "required_with_all" => "O campo :attribute é obrigatório quando um dos :values está presente.",
    "required_without" => "O campo :attribute é obrigatório quanto :values não está presente.",
    "required_without_all" => "O campo :attribute é obrigatório quando nenhum dos :values está presente.",
    "same"             => "Os campos :attribute e :other deverão conter valores iguais.",
    "size"             => [
        "numeric" => "O campo :attribute deverá conter o valor :size.",
        "file"    => "O campo :attribute deverá ter o tamanho de :size kilobytes.",
        "string"  => "O campo :attribute deverá conter :size caracteres.",
        "array"   => "O campo :attribute deve ter :size itens.",
    ],
    "string"           => "O campo :attribute deve ser uma string.",
    "timezone"         => "O campo :attribute deverá ter um fuso horário válido.",
    "unique"           => "O valor indicado para o campo :attribute já se encontra utilizado.",
    "url"              => "O formato do URL indicado para o campo :attribute é inválido.",

    /*
    |--------------------------------------------------------------------------
    | Custom Validation Language Linesome
    |--------------------------------------------------------------------------
    |
    | Here you may specify custom validation messages for attributes using the
    | convention "attribute.rule" to name the lines. This makes it quick to
    | specify a specific custom language line for a given attribute rule.
    |
    */

    'custom' => [
        'name' => [
            'alpha_spaces' => 'O campo Nome deve conter apenas letras',
            'between' => 'O campo Nome deverá ter no máximo 100 caracteres',
        ],
        'razao_social' => [
            'alpha_spaces' => 'O campo Razão Social deve conter apenas letras',
            'between' => 'O campo Nome deverá ter no máximo 200 caracteres',
        ],
       'state_registration' => [
           'digits_between' => 'O campo Inscrição Estadual deve conter apenas números',
        ],

        'address' => [
            'between' => 'O campo Endereço deverá ter no máximo 100 caracteres',
        ],

 'address_num' => [
            'alpha_num' => 'O campo Número não pode conter caracteres especiais',
        ],

        'address_neighborhood' => [
            'alpha_spaces' => 'O campo Bairro deve conter apenas letras',
            'between' => 'O campo Bairro deverá ter no máximo 50 caracteres',
        ],

        'city' => [
            'alpha_spaces' => 'O campo Cidade deve conter apenas letras',
            'between' => 'O campo Cidade deverá ter no máximo 50 caracteres',
        ],
        'state' => [
            'alpha_spaces' => 'O campo Estado deve conter apenas letras',
            'between' => 'O campo Estado deverá ter no máximo 50 caracteres',
        ],
        'cep' => [
            'integer' => 'O campo CEP deve conter apenas números',
            'digits' => 'O campo CEP deverá ter exatamente 8 dígitos',
        ],

         'min_time' => [
            'integer' => 'O campo Tempo Mínimo deve conter apenas números',
            'min' => 'O campo Tempo Mínimo deve ter valor mínimo de 1 minuto',
        ],

         'un_price' => [
            'numeric' => 'O campo Preço Unitário deve conter apenas números',
            'min' => 'O campo Preço Unitário deve ter valor mínimo de R$ 0.1',
        ],

        'un_time' => [
            'integer' => 'O campo Tempo Unitário deve conter apenas números',
            'min' => 'O campo Tempo Unitário deve ter valor mínimo de 1 minuto',
        ],

        'discount_sellers' => [
            'integer' => 'O campo Desconto para vendedor deve conter apenas números',
            'max' => 'Desconto para vendedor não pode ser maior que 100%',
        ],

        'max_price' => [
            'integer' => 'O campo Tempo Máximo deve conter apenas números',
            'min' => 'O campo Tempo Máximo deve ter valor mínimo de 1 minuto'
        ],

         'cpf' => [
            'numeric' => 'O campo CPF deve conter apenas números',
            'digits' => 'O campo CPF deve ter exatamente 11 dígitos'
        ],


    ],

    /*
    |--------------------------------------------------------------------------
    | Custom Validation Attributes
    |--------------------------------------------------------------------------
    |
    | The following language lines are used to swap attribute place-holders
    | with something more reader friendly such as E-Mail Address instead
    | of "email". This simply helps us make messages a little cleaner.
    |
    */

    'attributes' => [],

];
