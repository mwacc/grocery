<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../generalpages/header.jsp" %> 

<script type="text/javascript">
function calc() { 
	try {
		var currency = $('#select01 option:selected').val()
		var inweek = parseInt($('#input01').val());
		var inyear = inweek * 52;
		var safe = inyear * 0.25;
		$('#inyear').text(inyear + ' ' + currency)
		$('#safe').text(safe + ' ' + currency)
		$('#result').css('visibility', 'visible');
	}catch(e){alert(e);}
}
</script>

<p style="margin-bottom: 18px;" align="center">
	<iframe width="460" height="275" src="http://www.youtube.com/embed/Xmzg8ErJM7A?rel=0" frameborder="0" allowfullscreen></iframe>
</p>

<h3><a name="l1"></a> Simple shopping! </h3>
<p>
How often going to the store do you make a shopping list? On a piece of paper or in a smartphone - 
how much time does it take to put into the list all needed products - and don't forget that 80% of them you buy regularly! 
Let's say you've remembered all needed products and were able to put them into the list in the three minutes. It's fast, the most of people spend 
6-8 minutes, or even 10 or more! But are you sure that you won't forget to put into the list, for example, a shampoo or a milk?
There is already ready shopping lists which can help you and you have to mark the required goods only. It is very simple.
<a href="grocering.me">grocering.me</a> proposes shopping list templates, where you must check out the appropriate products 
(all products are categorized) and to add the missing, as the ability to create your own shopping list and reuse it in the future.<br/>
Quickly. Simple. Effectively. Grocering.me 
<a href="<%=request.getContextPath()%>/register.jsp" ><fmt:message key="index.signup" /></a>
</p>

<h3><a name="l2"></a> Save up to 25% of your money, save your time and do not forget anything!</h3>
<p>
Using a shopping list, you can save up to 25% on the shopping! According to the research, unnecessary expenses are usually impulsive and 
they are easy to avoid making shopping according to the list. Also, the list of products will save valuable time, especially 
if the products are separated by categories and most important - you will not forget to buy anything, because you have a ready list, 
in which you can quickly point out the needed products and adds the missing!<br/>
Quickly. Simple. Effectively. Grocering.me
<a href="<%=request.getContextPath()%>/register.jsp" ><fmt:message key="index.signup" /></a>
<div class="span8 offset2">
<form class="form-horizontal well">
  <fieldset>
    <legend>How much do I spend on a goods?</legend>
    <p>
      I instantly spend in a week:
        	<input type="text" maxlength="5" size="5" id="input01" class="span2"/>
        	<select id="select01" class="span2" >
                <option value="GBP">GBP</option>
                <option value="EUR">EUR</option>
                <option value="RUB">RUB</option>
                <option value="UAH">UAH</option>
                <option selected value="USD">USD</option>
            </select>
      <div class="" style="visibility: hidden;" id="result">
      	<p>So, you spend <b id="inyear"></b> per year!</p>
      	<p>With grocery list you will be able to <b>save up to</b> <b id="safe"></b> per year</p>
      </div>
    </p>
    <div align="center">
      <button type="button" class="btn btn-primary" onclick="calc();return false;">Calc</button>
    </div>
  </fieldset>
</form>
</div>
</p>