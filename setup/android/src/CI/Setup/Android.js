import { setup } from 'fluentci:dependency/setup-java';

// The dependency's real WIT contract uses one record and optional named fields.
export const setupJava = version => () => setup({ version });
