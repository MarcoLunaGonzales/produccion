<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>MINKA</title>
            <link rel="STYLESHEET" type="text/css" href="css/ventas.css" /> 
            <script type="text/javascript" src='js/general.js' ></script>
            <script>
                function validar(){                
                    return true;
                }
                
            </script>
            <style type="text/css">
                .headerClassACliente
                {
                    font-weight:bold;

                    background-image:none;
                    background-color:#9d5a9e;
                    color:white;
                    height: 22px;
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                    font-size: 12px;
                }
                
            </style>
        </head>
        <body onload="document.getElementById('form1:nombreUsuario').focus();">
            <h:form id="form1"  >
                <br>
                <div align="center" >
                    <rich:simpleTogglePanel   label="Ingresar a MinkaProd" width="35%" headerClass="headerClassACliente"  switchType="client">
                        <h:panelGrid columns="3"  width="100%">
                            <h:outputText value="Usuario" styleClass="negrilla"  />
                            <h:outputText value=":" styleClass="negrilla"   />
                            <h:inputText  size="27"  styleClass="inputText"   value="#{ManagedAccesoSistema.usuarioModuloBean.nombreUsuario}" id="nombreUsuario" />
                            <h:outputText value="Clave de Acceso" styleClass="negrilla"  />
                            <h:outputText value=":" styleClass="negrilla"   />
                            <h:inputSecret  size="27"  styleClass="inputText"   value="#{ManagedAccesoSistema.usuarioModuloBean.contraseniaUsuario}" id="contraseniaUsuario" /> 
                        </h:panelGrid>
                        <h:panelGrid columns="1" style="text-align:center;vertical-align:center"  width="100%">
                            <h:commandButton value="Ingresar" styleClass="btn" action="#{ManagedAccesoSistema.actionVerficarUsuario}"   /> 
                            <h:outputText  styleClass="negrilla"    value="#{ManagedAccesoSistema.mensajeErrorGlobal}" 
                                           style="color:red"/>
                            <h:outputText value="Para restablecer su contraseña de click en el siguiente link" rendered="#{ManagedAccesoSistema.cantidadDiasFaltantesVencimiento < 0}"
                                          styleClass="outputText2"/>
                            <a4j:commandLink value="#{ManagedAccesoSistema.cantidadDiasFaltantesVencimiento < 0 ? 'Restablecer Contraseña':'¿Olvido su contraseña?'}"
                                             style="color:blue"
                                             rendered="#{ManagedAccesoSistema.mensajeErrorGlobal != '' || ManagedAccesoSistema.cantidadDiasFaltantesVencimiento < 0}"
                                             oncomplete="window.location.href='accesoSistema/restablecerContrasena.jsf?data='+(new Date()).getTime().toString()"/>
                        </h:panelGrid>
                        
                        
                    </rich:simpleTogglePanel>
                    
                </div>
            </h:form>
            
        </body>
    </html>
</f:view>


