<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><g:layoutTitle /></title>
    <r:require modules="bie"/>
    <r:layoutResources/>
    <g:layoutHead />
    <script src="http://use.typekit.net/whd1tbp.js"></script>
    <script>try{Typekit.load();}catch(e){}</script>
    <!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->
</head>
<body class="${pageProperty(name:'body.class')?:''}" id="${pageProperty(name:'body.id')}" onload="${pageProperty(name:'body.onload')}">
<div class="wrap">

    <!-- start generic header -->
    <header style="text-align: center; background-color: #999; padding: 20px; margin-bottom: 30px;">
        <h1 style="margin: 0;">Header</h1>
    </header>
    <!-- end generic footer -->

    <g:layoutBody/>
    <div class="push"></div>

    <!-- start generic footer -->
    <footer class="site-footer" style="text-align: center; background-color: #999; padding: 20px;">
        <h3 style="margin: 0;">Footer</h3>
    </footer>
    <!-- end generic footer -->

</div><!-- end wrap -->
<r:layoutResources/>
</body>
</html>