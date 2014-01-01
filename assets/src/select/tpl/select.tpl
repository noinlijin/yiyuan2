{{#data}}
  <div class="questioin-item" value="{{id}}">
    <div class="question">{{question}}</div>
    <table width="100%" class="select-value ">
    {{#values}}
      <td >
        <label class="radio" for="">
          <input type="radio" name="{{pId}}" value="{{value}}"/>{{value_contain}}
        </label>
      </td>
    {{/values}}                    
    </tr>
    </table>
  </div>

{{/data}}
