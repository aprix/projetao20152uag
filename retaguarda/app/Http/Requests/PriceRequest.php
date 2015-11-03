<?php

namespace Retaguarda\Http\Requests;

use Retaguarda\Http\Requests\Request;

class PriceRequest extends Request
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
            'min_time' => 'required|integer|min:1',
            'un_price' => 'required|numeric|min:0.1',
            'un_time' => 'required|integer|min:1',
            'discount_sellers' => 'required|integer|min:0|max:100',
            'max_price' => 'required|integer|min:1'
        ];
    }
}
