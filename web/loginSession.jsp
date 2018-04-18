<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <body>
            <h:form id="form1"  >
                    <h:outputText value="#{ManagedAccesoSistema.verificarSessionUsuario}"/>
            </h:form>
            
        </body>
    </html>
</f:view>


