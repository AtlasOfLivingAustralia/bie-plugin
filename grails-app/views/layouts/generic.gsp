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
    <nav class="navbar navbar-inverse navbar-fixed-top">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="#">
                    %{--<img alt="Brand" class="img-responsive" src="::headerFooterServer::/img/supporting-graphic-element-flat.png">--}%
                </a>
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand font-xsmall" href="#">${grailsApplication.config.skin.orgNameLong?:'ALA Demo'}</a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <g:form class="navbar-form navbar-left" role="search" controller="species" action="search" method="get">
                    <div class="form-group">
                        <input type="text" class="form-control general-search" placeholder="Search the Atlas" name="q" ></div>
                    <button type="submit" class="btn btn-primary">Search</button>
                </g:form>
            </div>
        </div><!-- /.navbar-collapse -->
    </nav><!-- /.container-fluid -->
    <div class="push"></div>
    <!-- end generic header -->

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