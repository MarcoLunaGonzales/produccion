<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <link rel="STYLESHEET" type="text/css" href="css/ventas.css" /> 
            <script type="text/javascript" src="js/general.js" ></script> 
            <style type="text/css">
                .divisionLinea
                {
                    border-right:1px solid #bbbbbb;
                }
                .cabeceraSistema
                {
                    background-color:#4c1f49;
                    color: white;
                    display:block;
                }
                .cabeceraSistema div
                {
                    padding-left:4px;
                    padding-right:4px;
                }
                .textoCofar
                {
                    font-weight:bold;
                    font-size:22px;
                    font-style: italic;
                }
                .textoAtlas
                {
                    font-weight:bold;
                    font-size:18px;
                    font-style: italic;
                }
                .cabeceraSistema a
                {
                    color: white;
                    font-weight: bold;
                    font-size: 7px;
                    
                }
                .spanProximoVencer{
                    padding: 0px;
                    font-size: 10px;
                    font-weight: bold;
                    border: 1px solid red;
                    color:red;
                    background-color: yellow;
                }
            </style>
        </head>
        <body class="cabeceraSistema">
            <table style="width: 100%;" cellpadding="0" cellspacing="0">
                <tr>
                <td style="width: 33%"><img src="img/logoCrespal.png" style="height:30px"/><span class="textoAtlas"></span></td>
                <td style="width: 34%;text-align: center"><span class="textoCofar">MRP - MPS / MinkaProd</span>
                    <br/><h:outputText styleClass="spanProximoVencer" value="Debe realizar el cambio de contraseña le quedan #{ManagedAccesoSistema.cantidadDiasFaltantesVencimiento} dias para el vencimiento" rendered="#{ManagedAccesoSistema.cantidadDiasFaltantesVencimiento <= 7}"/>
                </td>
                <td style="width: 33%;text-align:right;vertical-align: middle">
                    <h:outputText value="Usuario :" styleClass="outputTextBold"/> <h:outputText styleClass="outputText2" value="#{ManagedAccesoSistema.usuarioModuloBean.nombrePilaUsuarioGlobal} #{ManagedAccesoSistema.usuarioModuloBean.apPaternoUsuarioGlobal} #{ManagedAccesoSistema.usuarioModuloBean.apMaternoUsuarioGlobal}" />
                    <br><a href="#" onclick="window.parent.location.href='logout.jsf'"><h:outputText styleClass="outputText2" style="font-weight:bold;font-size:10px" value="[Cerrar Sesion]"/></a>
                </td>
                </tr>


            </div>
        </body>
    </html>
    
</f:view>

