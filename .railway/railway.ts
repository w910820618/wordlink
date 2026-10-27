import { defineRailway, github, project, service } from "railway/iac";
// This repository manages only its own resources in the environment. Other
// repositories export their own partial name.
// See https://docs.railway.com/infrastructure-as-code#multi-repo-projects
export const partial = "wordlink";
export default defineRailway(() => {
  const wordlink = service("wordlink", {
    source: github("w910820618/wordlink", { branch: "main", checkSuites: false }),
    build: { buildCommand: "npx prisma generate && npm run build", buildEnvironment: "V3", builder: "RAILPACK" },
    start: "npm run start",
    healthcheck: "/",
    healthcheckTimeout: 300,
    preDeploy: "npx prisma migrate deploy",
    replicas: { "asia-southeast1-eqsg3a": 1 },
  });

  return project("wordlink", {
    variables: { managed: false },
    resources: [wordlink],
  });
});
