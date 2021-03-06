import { DeployFunction } from 'hardhat-deploy/types';

const deploy: DeployFunction = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer, pancakeswapRouter } = await getNamedAccounts();

  const ledgityRouterDeployResult = await deploy('LedgityRouter', {
    from: deployer,
    args: [pancakeswapRouter],
    log: true,
  });

  await deployments.execute(
    'Ledgity',
    { from: deployer, log: true },
    'setIsExcludedFromDexFee',
    ledgityRouterDeployResult.address,
    true,
  );
  await deployments.execute(
    'Ledgity',
    { from: deployer, log: true },
    'setIsExcludedFromLimits',
    ledgityRouterDeployResult.address,
    true,
  );
};

deploy.tags = ['ledgity-router'];

export default deploy;
