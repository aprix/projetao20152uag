<?php

namespace Retaguarda\Http\Requests;

use Retaguarda\Http\Requests\Request;

class SearchRequest extends Request
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

            
            'cpf' => 'required|numeric|digits:11',
        
        ];
    }
}
