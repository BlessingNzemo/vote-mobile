import 'package:flutter/material.dart';
import 'package:odc_mobile_project/m_evaluation/ui/pages/evaluation/end/endTimePage.dart';
import 'package:odc_mobile_project/m_evaluation/ui/pages/evaluation/intro/introEvaluationPage2.dart';
import 'package:odc_mobile_project/m_evaluation/ui/pages/infoPage/InfoPage.dart';
import 'package:odc_mobile_project/m_evaluation/ui/pages/intervenantPage/intervenantPage2.dart';
import 'package:odc_mobile_project/m_evaluation/ui/pages/intervenantPage/intervenantPage3.dart';
import 'package:odc_mobile_project/m_evaluation/ui/pages/phasePage/PhasePageTest.dart';
import 'package:odc_mobile_project/m_user/business/interactor/UserInteractor.dart';
import 'package:odc_mobile_project/m_user/ui/pages/TestPage.dart';
import 'package:odc_mobile_project/m_user/ui/pages/login/LoginPage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import '../m_evaluation/ui/pages/AuthPage/AuthPage3.dart';
import '../m_evaluation/ui/pages/IntroPage/intropage3.dart';
import '../m_evaluation/ui/pages/SaisieCouponPage/SaisieCouponPage.dart';
import '../m_evaluation/ui/pages/ScanCouponPage/ScanCouponPage.dart';
import '../m_evaluation/ui/pages/evaluation/EvaluationPage.dart';
import '../m_evaluation/ui/pages/evaluation/end/endPage.dart';
import '../m_evaluation/ui/pages/phasePage/PhasePage2.dart';
import '../m_evaluation/ui/pages/vote/VotePage2.dart';
import '../m_evaluation/ui/pages/vote/VotePage3.dart';

part "routers.g.dart";


enum Urls { home, detailArticle, auth,
  login,  test, Intro,
  scanner,  evaluationAuth, phases,
  intervenants,info , evaluationExpired,
  evaluation, EvaluationFinalStep, introEvaluation,
  saisieCoupon,vote, evaluationEndStep, }

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  final userInteractor = ref.watch(userInteractorProvider);
  return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: "/auth/intro",
      redirect: (context, state) async {
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: "/home",
          name: Urls.home.name,
          builder: (ctx, state) => PhasePageTest(),
          routes: <RouteBase>[
            GoRoute(
                path: 'test',
                name: Urls.test.name,
                builder: (ctx, state) => Testpage()),
            GoRoute(
              path: "details/:id",
              name: Urls.detailArticle.name,
              pageBuilder: (ctx, state) {
                final articleId = state.pathParameters["id"];
                return MaterialPage(key: state.pageKey, child: LoginPage());
              },
            ),
            GoRoute(
              path: 'vote/:phaseId/:intervenantId',
              name: Urls.vote.name,
              pageBuilder: (ctx, state) {
                var phaseIdStr=state.pathParameters["phaseId"]?? '-1';
                final phaseId = int.tryParse(phaseIdStr) ?? -1;
                var intervenantIdStr=state.pathParameters["intervenantId"]?? '-1';
                final intervenantId = int.tryParse(intervenantIdStr) ?? -1;
                return MaterialPage(key: state.pageKey, child: VotePage2(phaseId: phaseId,phaseIntervenantId: intervenantId));
              },),
            GoRoute(
              path: "phases",
              name: Urls.phases.name,
              pageBuilder: (ctx, state) {
                return MaterialPage(key: state.pageKey, child: PhasePageTest());
              },
            ),
            GoRoute(
              path: "intervenants/:id",
              name: Urls.intervenants.name,
              pageBuilder: (ctx, state) {
                var id=state.pathParameters["id"]?? '-1';
                final phaseId = int.tryParse(id) ?? -1;
                return MaterialPage(key: state.pageKey, child: IntervenantPage2(phaseId: phaseId,));


              },
            ),
            GoRoute(path: "info",
                name: Urls.info.name,
                builder: (ctx, state) => InfoPage()),


            GoRoute(
                path: 'introEvaluation',
                name: Urls.introEvaluation.name,
                builder: (ctx, state) => IntroEvaluationPage2()),



             GoRoute(
                 path: 'evaluation',
                 name: Urls.evaluation.name,
                 builder: (ctx, state) => EvaluationPage()),


            GoRoute(
                path: 'EvaluationFinalStep',
                name: Urls.EvaluationFinalStep.name,
                builder: (ctx, state) => EndPage()),

            GoRoute(
                path: 'evaluationEndStep',
                name: Urls.evaluationEndStep.name,
                builder: (ctx, state) => EndTimePage()),

          ],
        ),
        GoRoute(
            path: "/auth",
            name: Urls.auth.name,
            builder: (ctx, state) => IntroPage3(),
            routes: <RouteBase>[

              GoRoute(
                  path: 'intro',
                  name: Urls.Intro.name,
                  builder: (ctx, state) => IntroPage3()),
              GoRoute(
                path: "evaluation-auth",
                name: Urls.evaluationAuth.name,
                builder: (ctx, state) => AuthPage3(),
              ),
              GoRoute(
                path: 'scanner/:type',
                name: Urls.scanner.name,
                pageBuilder: (ctx, state) {
                  var type=state.pathParameters["type"]?? '';
                  return MaterialPage(key: state.pageKey, child: ScanCouponPage(type: type,));
                },
              ),
              GoRoute(
                path: 'saisieCoupon',
                name: Urls.saisieCoupon.name,
                builder: (ctx, state) => SaisieCouponPage(),)

            ]),
      ],
      errorBuilder: (ctx, state) => IntroPage3());

}
