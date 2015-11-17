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
            'name' => 'required|alpha_spaces|between:1,100',
            'razao_social' => 'required|alpha_spaces|between:1,200',
            'state_registration' => 'digits_between:0,200',
            'address' => 'required|between:1,100',
            'address_num' => 'required|alpha_num',
            'address_neighborhood' => 'required|alpha_spaces|between:1,50',
            'city' => 'required|alpha_spaces|between:1,50',
            'state' => 'required|alpha_spaces|between:1,50',
            'cep' => 'required|integer|digits:8',
            

        ];
    }
}
