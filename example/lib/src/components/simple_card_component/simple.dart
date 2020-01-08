import 'package:essential_components/essential_components.dart';

class Simple implements SimpleCardRender {
  @override
  SimpleCardModel getModel() {
    SimpleCardModel data = SimpleCardModel();
    data.guid = 'ContactSuport';
    data.contentTitle = 'Suporte';
    data.content = '<p class="text-center">Para entrar em contato com a equipe de suporte,<br> ligue no telefone (22) 2771-6187 ou <br> em um dos ramais 6187 e 6249.<p>';
    data.linkUrl = '';
    data.alignBtn = 'center';
    data.linkLabel = 'Ligar agora';
    data.templateLink = TemplateLink.BUTTON;
    data.btnColor = 'orange';
    data.icon = 'lifebuoy';
    data.iconColor = 'orange';
    return data;
  }
}