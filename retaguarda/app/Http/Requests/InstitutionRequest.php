<?php

namespace Retaguarda\Http\Requests;

use Retaguarda\Http\Requests\Request;

class InstitutionRequest extends Request
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            
            'cnpj' => 'required|numeric|digits:14',
            'name' => 'required|between:1,100',
            'razao_social' => 'required|between:1,200',
            'state_registration' => 'integer',
            'adress' => 'required|between:1,100',
            'adress_num' => 'required|integer',
            'adress_neighborhood' => 'required|between:1,50',
            'city' => 'required|between:1,50',
            'state' => 'required|between:1,50',
            'cep' => 'required|integer|digits:8',


        ];
    }
}
