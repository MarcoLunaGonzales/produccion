<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <style  type="text/css">
                .a{
                    background-color : #F2F5A9;
                }
                .b{
                    background-color : #ffffff;
                }
                .columns{
                    border:0px solid red;
                }
                .simpleTogglePanel{
                    text-align:center;
                }
                .ventasdetalle{
                    font-size: 13px;
                    font-family: Verdana;
                }
                .preciosaprobados{
                    background-color:#33CCFF;
                }
                .enviado{
                    background-color:#FFFFCC;
                }
                .pasados{
                    background-color:#ADD797;
                }
                .pendiente{
                    background-color : #ADD797;
                }
                .leyendaColorAnulado{
                    background-color: #FF6666;
                }
            </style>
        </head>
        <body>
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedUsuario.initModificarUsuario}"  />
                    <h3 align="center">Cambiar Contraseña Usuario</h3>

                    <h:panelGrid columns="2"   cellpadding="0"  cellspacing="2" headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Introducir Datos"/>
                        </f:facet>

                        <h:outputText value="nombre Personal ::"  styleClass="outputText2"/>
                        <h:inputText value="#{ManagedUsuario.personalModificar.apellidosNombres}" styleClass="inputText" readonly="true" size="50" />

                        <h:outputText value="Usuario ::"  styleClass="outputText2"/>
                        <h:inputText value="#{ManagedUsuario.personalModificar.nombreUsuario}" styleClass="inputText" readonly="true" />

                        <h:outputText value="Contraseña Actual::"  styleClass="outputText2"/>
                        <h:inputSecret value="#{ManagedUsuario.personalModificar.contrasenaUsuarioEscrito}" styleClass="inputText" />

                        <h:outputText value="Nueva Contraseña ::"  styleClass="outputText2"/>
                        <h:inputSecret value="#{ManagedUsuario.personalModificar.nuevaContrasenaUsuario}" styleClass="inputText" />

                        <h:outputText value="Re Escribir Contraseña ::"  styleClass="outputText2"/>
                        <h:inputSecret value="#{ManagedUsuario.personalModificar.reEscribirNuevaContrasenaUsuario}" styleClass="inputText" />

                    </h:panelGrid>
                    <br>
                    <a4j:commandButton value="Aceptar" styleClass="btn" ajaxSingle="false" action="#{ManagedUsuario.aceptarCambioPassword_action}" reRender="form1" oncomplete="if(#{ManagedUsuario.mensajes!=''}){alert('#{ManagedUsuario.mensajes}');}" />
                    <h:commandButton value="Cancelar"  styleClass="btn"   action="#{ManagedUsuario.cancelarCambioPassword_action}" />

                </div>


            </a4j:form>

        </body>
    </html>

</f:view>

