<?php

namespace Retaguarda\Http\Requests;

use Retaguarda\Http\Requests\Request;

class FiscalRequest extends Request
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

            'name' => 'required|alpha|between:1,100',
            'rg' => 'required|numeric',
        ];
    }
}
