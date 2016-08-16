<?php

namespace Drupal\auto_screenshots\Tests;

/**
 * Builds the demo site for the User Guide, English, with screenshots.
 *
 * See README.txt file in the module directory for more information about
 * making screenshots.
 *
 * @group UserGuide
 */
class UserGuideDemoTestEn extends UserGuideDemoTestBase {

  /**
   * {@inheritdoc}
   */
  protected $runList = [
    'doPrefaceInstall' => 'skip',
    'doBasicConfig' => 'skip',
    'doBasicPage' => 'skip',
    'doContentStructure' => 'skip',
    'doUserAccounts' => 'skip',
    'doBlocks' => 'skip',
    'doViews' => 'restore',
    'doMultilingual' => 'skip',
    'doExtending' => 'skip',
    'doPreventing' => 'skip',
    'doSecurity' => 'skip',
  ];
}
