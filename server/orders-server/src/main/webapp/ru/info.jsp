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

<h3><a name="l1"></a> Простые покупки!</h3>
<p>
Насколько часто собираясь в магазин за покупками, вы составляете список покупок - на листочке или в смартфоне - 
сколь времени занимает внести нужные товары? A ведь 80% из них вы регулярно покупаете! Допустим, вы вспомнили все 
нужные товары и смогли внести их, скажем, за 3и минуты. Это быстро, большинство людей тратят 6-8 минут, а то и 
более 10ти! Но где гарантия, что вы не забыли внести шампунь или молоко?
<br/>
Именно в такой момент вам на помощь придут готовые списки покупок, где вам нужно просто отметить необходимые товары.
<i>grocering.me</i> предлагает набор как готовых списков, в которых вам нужно просто отметить нужные товары 
(все товары категоризированы) 
и дописать недостающие, так и возможность создать свой собственный список покупок и многократно использовать его 
в будущем.
<br/>Быстро. Просто. Эффективно. Grocering.me 
<a href="<%=request.getContextPath()%>/register.jsp" ><fmt:message key="index.signup" /></a>
</p>

<h3><a name="l2"></a> Экономьте до 25%, берегите свое время и ничего не забывайте!</h3>
<p>
Используя список покупок, вы можете экономить 25% на продуктах! Согласно иследованиям, ненужные траты обычно происходят
импульсивно и их легко избежать совершая покупки по списку. Также, список товаров позволяет сэкономить бесценное время,
особенно если товары разнесены по категориям (как в <i>Grocering.me</i>) и главное - ничего не забыть купить,
ведь теперь вы имеете уже готовый список, в котором быстро отмечаете нужные товары и дописываете недостающие!
<br/>Быстро. Просто. Эффективно. Grocering.me
<a href="<%=request.getContextPath()%>/register.jsp" ><fmt:message key="index.signup" /></a>
<div class="span8 offset2">
<form class="form-horizontal well">
  <fieldset>
    <legend>Сколько я могу сэкономить на продуктах?</legend>
    <p>
      В неделю я трачу на продукты
        	<input type="text" maxlength="5" size="5" id="input01" class="span2"/>
        	<select id="select01" class="span2" >
                <option value="GBP">GBP</option>
                <option value="EUR">EUR</option>
                <option selected value="RUB">RUB</option>
                <option value="UAH">UAH</option>
                <option value="USD">USD</option>
            </select>
      <div class="" style="visibility: hidden;" id="result">
      	<p>Что в год составляет <b id="inyear"></b> !</p>
      	<p>Список продуктов позволит <b>сэкономить</b> <b id="safe"></b> в год</p>
      </div>
    </p>
    <div align="center">
      <button type="button" class="btn btn-primary" onclick="calc();return false;">Узнать</button>
    </div>
  </fieldset>
</form>
</div>
</p>