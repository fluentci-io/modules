// Build fixture input from an actual public operation, without requiring a
// synthetic version export on tools that do not provide one.
export function dependencyOperation(cli, schema, omitted) {
 const commands = cli.commands.filter(command => schema.exports[command.name]);
 const command = ['version', 'help', 'run'].map(name => commands.find(command => command.name === name)).find(Boolean) ?? commands[0];
 if (!command) throw Error(`${cli.name}: no public operation for dependency fixtures`);
 const contract = schema.exports[command.name].input;
 const input = Object.fromEntries(Object.entries(contract.properties).map(([key, property]) => {
  if (key === 'runDir') return [key, '/tmp/setup-dependency-run'];
  if (!contract.required.includes(key)) return [key, omitted];
  const field = command.fields.find(field => field.key === key);
  const sample = field?.sample ?? property.enum?.[0] ?? property.default;
  if (sample === undefined || sample === null) throw Error(`${cli.name}.${command.name}: missing fixture sample for ${key}`);
  return [key, sample];
 }));
 return {name: command.name, input};
}
