// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonRetry => 'Tentar novamente';

  @override
  String get commonSave => 'Salvar';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Nível $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'Seu progresso';

  @override
  String get nonogramDashboardStatCompleted => 'Concluídos';

  @override
  String get nonogramGuideIntro =>
      'Nonogramas são quebra-cabeças de lógica com regras simples e soluções desafiadoras. O objetivo é revelar imagens escondidas preenchendo quadrados de acordo com os números ao lado da grade.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'Se juntar dois blocos existentes formaria uma figura maior que qualquer dica disponível, o espaço entre eles deve ser um X.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Divisão';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Se um quadrado preenchido só pode pertencer a algumas variantes específicas de um bloco, todo quadrado que não é preenchido em nenhuma dessas variantes deve ser marcado com X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Posicionamento duplo';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Marque com um X os quadrados que não podem pertencer a nenhuma das figuras restantes.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Inacessibilidade';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Se um espaço vazio entre X é menor que qualquer dica disponível para aquela linha, ele deve ser marcado com X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Não cabe';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Quando há vários números, sobreponha as posições extremas à esquerda e à direita do grupo inteiro, considerando o espaço mínimo obrigatório de um quadrado entre blocos da mesma cor. Os quadrados em que um bloco coincide consigo mesmo nas duas variantes são preenchidos.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Sobreposição (várias dicas)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Se um número ocupa mais da metade da linha, alguns quadrados do meio com certeza serão preenchidos. Sobreponha as posições extremas à esquerda e à direita; onde elas coincidem, os quadrados são preenchidos.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Sobreposição (uma dica)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Se um quadrado preenchido conhecido está mais perto de uma borda do que o tamanho da primeira dica, a figura a que ele pertence deve se estender para longe dessa borda.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. Afastar das paredes';

  @override
  String get nonogramGuideRuleDesc =>
      'Cada número representa um bloco contínuo de quadrados preenchidos naquela linha ou coluna. Se houver vários números, eles representam blocos separados, e cada bloco deve estar separado do próximo por pelo menos um quadrado vazio. Por exemplo, `3 1` significa um bloco de 3 quadrados preenchidos, depois pelo menos 1 quadrado vazio e então um bloco de 1 quadrado preenchido.';

  @override
  String get nonogramGuideRuleTitle =>
      'Regra principal: o que os números significam';

  @override
  String get nonogramGuideTitle => 'Como resolver';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Concluído em $date';
  }

  @override
  String get nonogramHistoryDetailNotFound =>
      'Detalhes do nível não encontrados.';

  @override
  String get nonogramHistoryEmpty => 'Nenhum nível concluído ainda.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Nível $n';
  }

  @override
  String get nonogramHistoryTitle => 'Resultados';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Próximo nível';

  @override
  String get nonogramPlayActionShowClues => 'Mostrar dicas';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'Parabéns! Você concluiu o nível $level.';
  }

  @override
  String get nonogramPlayCompletionTitle => 'Quebra-cabeça resolvido!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'Dica ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast => 'Ainda não há próximo nível.';

  @override
  String get nonogramPlayPageTitle => 'Nonograma';

  @override
  String get nonogramSettingsTitle => 'Configurações';

  @override
  String get nonogramDashboardContinueNext => 'Próximo desafio';

  @override
  String get nonogramDashboardPlay => 'Jogar';

  @override
  String get nonogramDashboardResumeAction => 'Continuar';

  @override
  String get nonogramDashboardInProgressBadge => 'Em andamento';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Dificuldade $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '$completed de $total quebra-cabeças resolvidos';
  }

  @override
  String get nonogramDashboardStatFastest => 'Mais rápido';

  @override
  String get nonogramDashboardStatTotalTime => 'Tempo total';

  @override
  String get nonogramDashboardRecentTitle => 'Resolvidos recentemente';

  @override
  String get nonogramDashboardSeeAll => 'Ver todos';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Resolva seu primeiro quebra-cabeça para começar sua coleção de imagens.';

  @override
  String get nonogramDashboardAllDoneTitle =>
      'Todos os quebra-cabeças resolvidos!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'Você concluiu todos os $total quebra-cabeças. Reveja sua coleção quando quiser.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'Melhor $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'Início';

  @override
  String get appThemeTitle => 'Aparência';

  @override
  String get appThemeLight => 'Claro';

  @override
  String get appThemeDark => 'Escuro';

  @override
  String get nonogramPlayModeFill => 'Modo preencher';

  @override
  String get nonogramPlayModeMark => 'Modo marcar X';

  @override
  String get nonogramSettingsRestart => 'Reiniciar este nível';

  @override
  String get nonogramSettingsRestartConfirmTitle => 'Reiniciar este nível?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'Todos os quadrados que você preencheu ou marcou serão apagados. Os quadrados com estrela (abertos por dicas ou pela varinha) são mantidos.';

  @override
  String get commonClose => 'Fechar';

  @override
  String get nonogramSettingsRestartConfirm => 'Reiniciar';

  @override
  String get nonogramTutorialTitle => 'Como jogar';

  @override
  String get nonogramTutorialSkip => 'Pular';

  @override
  String get nonogramTutorialWelcomeTitle => 'Boas-vindas ao Nonopix!';

  @override
  String get nonogramTutorialWelcome =>
      'Vamos aprender as regras básicas com um pequeno quebra-cabeça 5×5.';

  @override
  String get nonogramTutorialStart => 'Começar';

  @override
  String get nonogramTutorialSwitchToFill =>
      'Os quebra-cabeças são resolvidos preenchendo quadrados. Toque no botão abaixo para mudar para o modo preencher.';

  @override
  String get nonogramTutorialClueIsCount =>
      'O número diz quantos quadrados da linha estão preenchidos. Esta linha tem 5, então preencha todos!';

  @override
  String get nonogramTutorialEdgeCell =>
      'O último quadrado já está preenchido. O bloco de 4 precisa incluí-lo, então só há um jeito de colocá-lo: preencha os 3 quadrados à esquerda dele.';

  @override
  String get nonogramTutorialMultipleClues =>
      'Mais de um número significa mais de um bloco, com pelo menos um quadrado vazio entre eles. 2 2 cabe nestes 5 quadrados de um único jeito.';

  @override
  String get nonogramTutorialClueOrder =>
      'A ordem também importa: 3 1 significa que o bloco de 3 vem primeiro e depois o bloco de 1.';

  @override
  String get nonogramTutorialColumns =>
      'As colunas também têm números, lidos de cima para baixo. Mude para o modo X para marcar os quadrados que devem ficar vazios.';

  @override
  String get nonogramTutorialMarkEmpty =>
      'As colunas com ✓ já têm todos os seus quadrados. Marque os quadrados vazios restantes delas com um X.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'O 1 da última linha agora só tem um lugar possível. Volte para o modo preencher.';

  @override
  String get nonogramTutorialFinish =>
      'Preencha o último quadrado para terminar o quebra-cabeça!';

  @override
  String get nonogramTutorialDoneTitle => 'Muito bem!';

  @override
  String get nonogramTutorialDone =>
      'Tudo pronto! Em quebra-cabeças grandes, arraste com dois dedos (ou a partir do espaço vazio fora da grade) para mover o tabuleiro; o app vai lembrar você no seu primeiro quebra-cabeça grande.';

  @override
  String get nonogramTutorialShowTechniques => 'Ver técnicas de resolução';

  @override
  String get nonogramTutorialPlay => 'Começar a jogar';

  @override
  String get nonogramGuideTutorialCardTitle => 'Aprenda jogando';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Aprenda as regras e os controles passo a passo em um pequeno quebra-cabeça 5×5.';

  @override
  String get nonogramPlayInfoHide => 'Ocultar informações do nível';

  @override
  String get nonogramPlayWandLabel => 'Varinha mágica';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Toque nas dicas da linha ou coluna que quer revelar';

  @override
  String get nonogramPlayWandRowSolved =>
      'Esta linha já está correta. Escolha outra linha ou coluna.';

  @override
  String get nonogramPlayWandColSolved =>
      'Esta coluna já está correta. Escolha outra linha ou coluna.';

  @override
  String get nonogramSettingsControlsGuide => 'Guia de controles';

  @override
  String get nonogramCoachSkip => 'Pular';

  @override
  String get nonogramCoachNext => 'Próximo';

  @override
  String get nonogramCoachDone => 'Entendi';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'Dica';

  @override
  String get nonogramCoachHintBody =>
      'Preenche para você 5 quadrados corretos (quadrados que deveriam estar preenchidos e ainda não estão), escolhidos aleatoriamente no tabuleiro inteiro. Eles ganham uma estrela: não podem ser alterados e são mantidos mesmo se você reiniciar. Você tem 3 por quebra-cabeça.';

  @override
  String get nonogramCoachWandTitle => 'Varinha mágica';

  @override
  String get nonogramCoachWandBody =>
      'Toque na varinha e depois nas dicas de qualquer linha ou coluna: a resposta da linha inteira é revelada e marcada com uma estrela, mantida mesmo se você reiniciar. Você tem 1 por quebra-cabeça.';

  @override
  String get nonogramCoachModeTitle => 'Preencher ou X';

  @override
  String get nonogramCoachModeBody =>
      'Escolha o que um toque faz: preencher o quadrado ou marcá-lo com um X para lembrar que ele está vazio. Toque no botão para alternar. Arraste pela grade para preencher ou marcar vários quadrados de uma vez.';

  @override
  String get nonogramCoachLongPressTitle => 'Toque e segure para o contrário';

  @override
  String get nonogramCoachLongPressBody =>
      'Toque e segure um quadrado para fazer o contrário do modo atual: X ao preencher, preencher ao marcar. Uma vibração curta indica que está feito e você pode soltar.';

  @override
  String get nonogramCoachScrollTitle => 'Navegando em quebra-cabeças grandes';

  @override
  String get nonogramCoachScrollBody =>
      'Quebra-cabeças grandes não cabem na tela: arraste com dois dedos, ou arraste a partir do espaço vazio fora da grade para mover o tabuleiro. Arraste sobre as dicas para ver os números ocultos (o \"+N\" no canto mostra quantos são).';

  @override
  String get nonogramTutorialRulesDoneTitle => 'Você já conhece as regras!';

  @override
  String get nonogramTutorialRulesDone =>
      'Agora vamos praticar os controles e as ajudas em outro quebra-cabeça: arrastar para preencher rápido, tocar e segurar para marcar, dicas e a varinha mágica.';

  @override
  String get nonogramTutorialContinue => 'Continuar';

  @override
  String get nonogramTutorialLater => 'Depois, só jogar';

  @override
  String get nonogramTutorialDragRow =>
      'Dica: deslize o dedo pelos quadrados para preenchê-los de uma vez. A linha de cima tem 5, então arraste pela linha inteira!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 cabe exatamente nestes 5 quadrados, então o 2º e o 4º quadrados devem ficar vazios. Não precisa mudar de modo: toque e segure cada um para marcá-lo com um X. Uma vibração curta indica que está feito.';

  @override
  String get nonogramTutorialUseHint =>
      'Travou? Toque no botão Dica e o app preenche 5 quadrados corretos aleatoriamente. Você tem 3 por quebra-cabeça.';

  @override
  String get nonogramTutorialActivateWand =>
      'A dica preencheu 5 quadrados marcados com estrela: eles ficam travados e são mantidos mesmo se você reiniciar. Para revelar uma linha ou coluna inteira à sua escolha, use a varinha mágica: toque no botão da varinha.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Agora toque nas dicas da linha de baixo para revelá-la. Você tem 1 varinha por quebra-cabeça.';

  @override
  String get nonogramTutorialFinishTools =>
      'Preencha os quadrados restantes para terminar. Arraste para baixo em uma coluna para preencher mais rápido.';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Todos os quadrados que deveriam estar preenchidos já estão. Verifique se há quadrados preenchidos a mais.';

  @override
  String get settingsSound => 'Som';

  @override
  String get settingsLicenses => 'Licenças';

  @override
  String get settingsSwitchPlayMode => 'Mudar modo de jogo';

  @override
  String get licensesTitle => 'Licenças';

  @override
  String get licensesLevelArtHeading => 'Quebra-cabeças';

  @override
  String get licensesLevelArtIntro =>
      'Os quebra-cabeças vêm destas fontes. Os conjuntos de ícones foram reduzidos, convertidos para preto e branco e editados para que todos os quebra-cabeças tenham solução; as coleções de nonogramas são usadas como estão.';

  @override
  String get licensesFontHeading => 'Fonte';

  @override
  String get licensesSoftwareButton => 'Licenças de software de código aberto';

  @override
  String get licensesDeveloperLevelsNote =>
      'Os quebra-cabeças do modo desenvolvedor vêm do nonogram.org e são apenas para testes internos. Eles não estão incluídos na versão da loja.';

  @override
  String get playModeTitle => 'Escolha um modo de jogo';

  @override
  String get playModeSubtitle =>
      'O progresso é salvo separadamente para cada modo.';

  @override
  String get playModeUserTitle => 'Modo jogador';

  @override
  String get playModeUserBody =>
      'Os quebra-cabeças licenciados que vêm na versão da loja.';

  @override
  String get playModeDeveloperTitle => 'Modo desenvolvedor';

  @override
  String get playModeDeveloperBody =>
      'Os quebra-cabeças originais do nonogram.org, para testes internos. Mantém seu progresso anterior.';

  @override
  String get playModeLastUsed => 'Último usado';

  @override
  String licensesBy(String author) {
    return 'Por $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count quebra-cabeças';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '$solved/$total resolvidos';
  }

  @override
  String get adRewardNotReady =>
      'O anúncio ainda não está pronto. Verifique sua conexão com a internet e tente novamente.';

  @override
  String get settingsAdPrivacy => 'Privacidade de anúncios';

  @override
  String get ratingTitle => 'Está gostando do Nonopix?';

  @override
  String get ratingMessage => 'Toque em uma estrela para avaliar o jogo.';

  @override
  String get ratingLater => 'Depois';

  @override
  String get ratingSubmit => 'Enviar';

  @override
  String get ratingThanks =>
      'Obrigado pela sua opinião! Vamos continuar melhorando o jogo.';

  @override
  String ratingStarLabel(int count) {
    return '$count estrelas';
  }

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Idioma do dispositivo';

  @override
  String get premiumTitle => 'Jogar sem anúncios';

  @override
  String get premiumBenefitNoAds => 'Sem anúncios entre os níveis';

  @override
  String get premiumBenefitDaily =>
      '2 dicas e 1 varinha mágica em cada dia de presença';

  @override
  String premiumBuy(String price) {
    return 'Comprar · $price';
  }

  @override
  String get premiumOneTime => 'Pagamento único pelo Google Play';

  @override
  String get premiumActiveTitle => 'Pacote sem anúncios ativo';

  @override
  String get premiumActiveDaily =>
      'Marque presença todo dia para receber 2 dicas e 1 varinha mágica para aquele dia.';

  @override
  String get premiumPurchased =>
      'Obrigado! Os anúncios entre os níveis foram desativados.';

  @override
  String get premiumPending =>
      'Seu pagamento está pendente. O pacote será ativado assim que for concluído.';

  @override
  String get premiumFailed => 'A compra não foi concluída. Tente novamente.';

  @override
  String get checkInTitle => 'Presença diária';

  @override
  String get checkInAction => 'Marcar presença';

  @override
  String get checkInDoneToday => 'Presença marcada hoje';

  @override
  String checkInNextGift(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Próximo presente em $count presenças',
      one: 'Próximo presente na sua próxima presença',
    );
    return '$_temp0';
  }

  @override
  String get checkInCheckedIn => 'Presença marcada!';

  @override
  String checkInReceived(String rewards) {
    return 'Você recebeu $rewards.';
  }

  @override
  String rewardHints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dicas',
      one: '1 dica',
    );
    return '$_temp0';
  }

  @override
  String rewardWands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count varinhas mágicas',
      one: '1 varinha mágica',
    );
    return '$_temp0';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (só hoje)';
  }

  @override
  String get checkInMonthGifts => 'Presentes do mês';

  @override
  String get navHome => 'Início';

  @override
  String get navMe => 'Eu';

  @override
  String get meHelp => 'Ajuda';

  @override
  String get meMore => 'Mais';

  @override
  String get checkInNotYetToday => 'Presença ainda não marcada hoje';

  @override
  String get checkInTodayButton => 'Marcar presença hoje';

  @override
  String checkInGiftsLeftShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count para um presente',
      one: 'Falta 1 para um presente',
    );
    return '$_temp0';
  }

  @override
  String get checkInGiftToday => 'Hoje tem presente!';

  @override
  String checkInGiftMilestone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Presente de $count presenças',
      one: 'Presente de 1 presença',
    );
    return '$_temp0';
  }

  @override
  String get checkInGiftCollect => 'Pegar';

  @override
  String get checkInTotalHints => 'Dicas';

  @override
  String get checkInTotalWands => 'Varinhas mágicas';

  @override
  String get checkInTotalDailyHints => 'Dicas (só hoje)';

  @override
  String get checkInTotalDailyWands => 'Varinhas mágicas (só hoje)';

  @override
  String get checkInPremiumToday => 'Hoje do seu pacote sem anúncios';

  @override
  String get checkInPremiumNotYet =>
      'Marque presença para receber 2 dicas e 1 varinha mágica para hoje.';

  @override
  String get checkInPremiumUsedUp => 'Tudo usado por hoje. Até amanhã!';

  @override
  String checkInExpiresIn(String time) {
    return 'Expira em $time';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'Você ainda tem $rewards para hoje. Expiram em $time, jogue agora para não desperdiçar!';
  }

  @override
  String get dashboardDailyReminderTitle =>
      'Suas ajudas de hoje estão esperando';

  @override
  String get dashboardDailyReminderPlay => 'Jogar agora';

  @override
  String get premiumViewBenefits => 'Ver benefícios';

  @override
  String get premiumBenefitsTitle => 'Benefícios do pacote';

  @override
  String get premiumBenefitsTagline =>
      'Compre uma vez para remover os anúncios entre os níveis e receber recompensas de ajuda todos os dias, para sempre na sua conta.';

  @override
  String get premiumBenefitsOneTime => 'pagamento único';

  @override
  String get premiumWhatYouGet => 'O que você recebe';

  @override
  String get premiumPerkNoAdsTitle => 'Sem anúncios entre os níveis';

  @override
  String get premiumPerkNoAdsBody =>
      'Chega de anúncios em tela cheia entre os quebra-cabeças. Avance de um nível para o outro sem interrupção.';

  @override
  String get premiumPerkDailyTitle => 'Recompensas diárias de presença';

  @override
  String get premiumPerkDailyBody =>
      'Cada presença dá a você 2 dicas extras e 1 varinha mágica para aquele dia, além das recompensas de marco habituais.';

  @override
  String get premiumItemsTitle => 'O que as ajudas fazem';

  @override
  String get powerUpHintName => 'Dica';

  @override
  String get powerUpHintTagline => 'Revela uma célula correta que você escolhe';

  @override
  String get powerUpHintDesc =>
      'Toque na lâmpada e escolha o ponto em que está na dúvida. O app preenche uma célula correta (preenchida ou marcada como vazia) para você destravar.';

  @override
  String get powerUpWandName => 'Varinha mágica';

  @override
  String get powerUpWandTagline => 'Resolve uma linha ou coluna inteira';

  @override
  String get powerUpWandDesc =>
      'Toque na varinha para ativar o modo de seleção e toque nos números de pista de uma linha ou coluna. O app revela essa linha ou coluna inteira. Mais forte que uma dica de uma única célula.';

  @override
  String get powerUpStatesTitle => 'O ícone mostra o tipo de uso';

  @override
  String get powerUpStatesLead =>
      'O número no canto é o total de usos restantes. Um uso por tempo limitado deixa o ícone dourado com um pequeno relógio:';

  @override
  String get powerUpTimeLimited => 'Por tempo limitado';

  @override
  String get powerUpTimeLimitedDesc =>
      'Ícone dourado com relógio. Da recompensa diária de presença do pacote. Expira no fim do dia.';

  @override
  String get powerUpPermanent => 'Permanente';

  @override
  String get powerUpPermanentDesc =>
      'Ícone normal com selo azul. Usos de marco e iniciais. Nunca expiram.';

  @override
  String get powerUpSpendOrderTitle => 'Quais usos são gastos primeiro?';

  @override
  String get powerUpSpendOrderHeading =>
      'Os usos por tempo limitado são gastos primeiro';

  @override
  String get powerUpSpendOrderBody =>
      'Os usos diários expiram no fim do dia, então uma dica ou varinha gasta primeiro os seus usos diários e só usa os permanentes quando os diários acabam. Nada é desperdiçado.';

  @override
  String get powerUpSpendDaily => 'Usos diários';

  @override
  String get powerUpSpendPermanent => 'Usos permanentes';

  @override
  String get premiumBenefitsFootnote =>
      'Os usos diários não passam para o dia seguinte. As recompensas de marco são usos permanentes e se acumulam normalmente.';
}
