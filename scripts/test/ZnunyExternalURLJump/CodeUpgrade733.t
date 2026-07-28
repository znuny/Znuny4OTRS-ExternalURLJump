# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);
use var::packagesetup::ZnunyExternalURLJump;

my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $CacheObject     = $Kernel::OM->Get('Kernel::System::Cache');

my $CodeObject = var::packagesetup::ZnunyExternalURLJump->new();

# trivial no-op paths, checked before anything is set up
$CacheObject->CleanUp(
    Type => 'ZnunyExternalURLJumpUpgrade733',
);

$Self->True(
    $CodeObject->CodeUpgrade( Version => '0.0.1' ),
    'CodeUpgrade with unknown Version is a no-op that still returns true.',
);

my %DefaultModuleSetting = $SysConfigObject->SettingGet(
    Name => 'Frontend::Module###AgentExternalURLJump',
);
$CodeObject->CodeUpgrade( Version => '7.3.3' );
my %StillDefaultModuleSetting = $SysConfigObject->SettingGet(
    Name => 'Frontend::Module###AgentExternalURLJump',
);
$Self->IsDeeply(
    $StillDefaultModuleSetting{EffectiveValue},
    $DefaultModuleSetting{EffectiveValue},
    'CodeUpgrade with nothing cached leaves settings untouched.',
);

# full pre -> post flow: simulate the old (pre-7.3.2) settings, customize some
# of them, run the real pre step, then the real post step, and check the result
my $StartedTransaction = $HelperObject->BeginWork();
$Self->True(
    $StartedTransaction,
    'Started database transaction.',
);

# the pre-7.3.2 setting names no longer exist in the currently installed package XML (it was
# renamed), so load a sample XML that still defines them - the same technique used in
# scripts/test/SysConfig/Migration/MigrateSysConfigSettings.t for its own old settings
my $Directory = $ConfigObject->Get('Home') . '/scripts/test/sample/ZnunyExternalURLJump/OldSettingsBefore732';
my $XMLLoaded = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => $Directory,
    Force     => 1,
    CleanUp   => 0,
);
$Self->True(
    $XMLLoaded,
    'Sample pre-7.3.2 setting XML loaded.',
);

my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
    Comments    => 'CodeUpgrade733.t setup',
    UserID      => 1,
    Force       => 1,
    AllSettings => 1,
);
$Self->True(
    $DeploymentResult{Success},
    'Sample settings deployed.',
);

# customize every field of two of the four old settings, leave the other two untouched
my $RandomID = $HelperObject->GetRandomID();

my %CustomModuleValue = (
    Group       => ["group-$RandomID"],
    GroupRo     => ["groupro-$RandomID"],
    Description => "Jump to External URL Description $RandomID",
    Title       => "Jump to External URL Title $RandomID",
    NavBarName  => "JumpToExternal $RandomID",
);

my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
    Name   => 'Frontend::Module###ExternalURLJump',
    UserID => 1,
);
$SysConfigObject->SettingUpdate(
    Name              => 'Frontend::Module###ExternalURLJump',
    IsValid           => 1,
    EffectiveValue    => \%CustomModuleValue,
    UserID            => 1,
    ExclusiveLockGUID => $ExclusiveLockGUID,
);
$SysConfigObject->SettingUnlock( Name => 'Frontend::Module###ExternalURLJump' );

my @CustomNavigationValue = (
    {
        Group       => ["navgroup-$RandomID"],
        GroupRo     => ["navgroupro-$RandomID"],
        Description => "Jump to Znuny Description $RandomID",
        Name        => "Jump to Znuny Name $RandomID",
        Link        => "Action=ExternalURLJump;URL=https%3A%2F%2Fexample.com%2F;Extra=$RandomID",
        LinkOption  => "target=\"_blank\" data-extra=\"$RandomID\"",
        NavBar      => "CustomNavBar-$RandomID",
        Type        => "CustomType-$RandomID",
        Block       => "CustomBlock-$RandomID",
        AccessKey   => "K$RandomID",
        Prio        => '77777',
    },
);

$ExclusiveLockGUID = $SysConfigObject->SettingLock(
    Name   => 'Frontend::Navigation###ExternalURLJump###1',
    UserID => 1,
);
$SysConfigObject->SettingUpdate(
    Name              => 'Frontend::Navigation###ExternalURLJump###1',
    IsValid           => 1,
    EffectiveValue    => \@CustomNavigationValue,
    UserID            => 1,
    ExclusiveLockGUID => $ExclusiveLockGUID,
);
$SysConfigObject->SettingUnlock( Name => 'Frontend::Navigation###ExternalURLJump###1' );

# make sure this code section is the same as in sopm file section CodeUpgrade

# mirrors the CodeUpgrade pre block inline in Znuny-ExternalURLJump.sopm - kept as a literal
# copy since that block can't be a callable sub (var/packagesetup is not installed yet at pre time)
my %RenamedSettings = (
    'Frontend::Module###ExternalURLJump'                 => 'Frontend::Module###AgentExternalURLJump',
    'Frontend::Navigation###ExternalURLJump###1'         => 'Frontend::Navigation###AgentExternalURLJump###1',
    'CustomerFrontend::Module###ExternalURLJump'         => 'CustomerFrontend::Module###CustomerExternalURLJump',
    'CustomerFrontend::Navigation###ExternalURLJump###1' =>
        'CustomerFrontend::Navigation###CustomerExternalURLJump###1',
);

OLDNAME:
for my $OldName ( sort keys %RenamedSettings ) {
    my %Setting = $SysConfigObject->SettingGet(
        Name  => $OldName,
        NoLog => 1,
    );

    next OLDNAME if !%Setting;
    next OLDNAME if !$Setting{IsModified};

    $CacheObject->Set(
        Type  => 'ZnunyExternalURLJumpUpgrade733',
        Key   => $RenamedSettings{$OldName},
        Value => {
            IsValid        => $Setting{IsValid},
            EffectiveValue => $Setting{EffectiveValue},
        },
        TTL => 60 * 30,
    );
}

$Self->True(
    scalar $CacheObject->Get(
        Type => 'ZnunyExternalURLJumpUpgrade733',
        Key  => 'Frontend::Module###AgentExternalURLJump'
    ),
    'Pre step captured the customized module setting.',
);
$Self->False(
    scalar $CacheObject->Get(
        Type => 'ZnunyExternalURLJumpUpgrade733',
        Key  => 'CustomerFrontend::Module###CustomerExternalURLJump'
    ),
    'Pre step did not capture the untouched customer module setting.',
);

# now run the real post step against what the (real) pre step above just cached
my $Success = $CodeObject->CodeUpgrade( Version => '7.3.3' );
$Self->True(
    $Success,
    'CodeUpgrade post step returns success.',
);

my %RestoredModuleSetting = $SysConfigObject->SettingGet(
    Name => 'Frontend::Module###AgentExternalURLJump',
);
$Self->IsDeeply(
    $RestoredModuleSetting{EffectiveValue},
    \%CustomModuleValue,
    'Frontend::Module###AgentExternalURLJump was restored to the full customized value (all fields).',
);

my %RestoredNavigationSetting = $SysConfigObject->SettingGet(
    Name => 'Frontend::Navigation###AgentExternalURLJump###1',
);
my $RestoredLink = $RestoredNavigationSetting{EffectiveValue}->[0]->{Link};
$Self->Is(
    index( $RestoredLink, 'Action=AgentExternalURLJump;' ),
    0,
    'Stale Action=ExternalURLJump in Link was rewritten to Action=AgentExternalURLJump.',
);

# only Link's Action prefix is expected to differ from what was cached, everything else
# (including the rest of the Link itself) must come back byte-for-byte identical
my %ExpectedNavigationItem = %{ $CustomNavigationValue[0] };
$ExpectedNavigationItem{Link} = $RestoredLink;
$Self->IsDeeply(
    $RestoredNavigationSetting{EffectiveValue}->[0],
    \%ExpectedNavigationItem,
    'Frontend::Navigation###AgentExternalURLJump###1 was restored to the full customized value (all fields).',
);

my %UntouchedCustomerModuleSetting = $SysConfigObject->SettingGet(
    Name => 'CustomerFrontend::Module###CustomerExternalURLJump',
);
$Self->False(
    $UntouchedCustomerModuleSetting{IsModified},
    'Untouched CustomerFrontend::Module###CustomerExternalURLJump was left at its default.',
);

# cache entries must be consumed by the run above, a second run must be a no-op
$CodeObject->CodeUpgrade( Version => '7.3.3' );
my %UnchangedAfterSecondRun = $SysConfigObject->SettingGet(
    Name => 'Frontend::Module###AgentExternalURLJump',
);
$Self->IsDeeply(
    $UnchangedAfterSecondRun{EffectiveValue},
    \%CustomModuleValue,
    'Second CodeUpgrade run is a no-op, value stays as already restored.',
);

# cleanup - Rollback() below undoes every DB write made above (including what CodeUpgrade did),
# the final ConfigurationDeploy re-syncs ZZZAAuto.pm to that rolled-back state
$CacheObject->CleanUp(
    Type => 'ZnunyExternalURLJumpUpgrade733',
);

my $RollbackSuccess = $HelperObject->Rollback();
$CacheObject->CleanUp();
$Self->True(
    $RollbackSuccess,
    'Rolled back all database changes and cleaned up the cache.',
);

my %Result = $SysConfigObject->ConfigurationDeploy(
    Comments    => 'CodeUpgrade733.t - revert changes.',
    UserID      => 1,
    Force       => 1,
    AllSettings => 1,
);
$Self->True(
    $Result{Success},
    'Configuration restored.',
);

1;
