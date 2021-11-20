import { useBackend } from '../backend';
import { Button, ByondUi, LabeledList, Section, ProgressBar, AnimatedNumber } from '../components';
import { Window } from '../layouts';
import { Table } from '../components/Table';

export const HelmConsole = (props, context) => {
  const { data } = useBackend(context);
  const { canFly, mapRef, isViewer } = data;
  return (
    <Window
      width={870}
      height={708}
      resizable>
      <div className="CameraConsole__left">
        <Window.Content>
          {canFly && !isViewer && (
            <ShipControlContent />
          )}
          {canFly && (
            <ShipContent />
          )}
          <SharedContent />
        </Window.Content>
      </div>
      <div className="CameraConsole__right">
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: mapRef,
            type: 'map',
          }} />
      </div>
    </Window>
  );
};

const SharedContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { isViewer, integrity, shipInfo = [], otherInfo = [] } = data;
  return (
    <>
      <Section
        title={shipInfo.can_rename && (
          <Button.Input
            content={shipInfo.name}
            currentValue={shipInfo.name}
            disabled={isViewer}
            onCommit={(e, value) => act('rename_ship', {
              newName: value,
            })} />
        ) || (shipInfo.name ? shipInfo.name : "Ship Info")}
        buttons={(
          <Button
            tooltip="Refresh Ship Stats"
            tooltipPosition="left"
            icon="sync"
            disabled={isViewer}
            onClick={() => act('reload_ship')} />
        )}>
        <LabeledList>
          <LabeledList.Item label="Class">
            {shipInfo.class}
          </LabeledList.Item>
          <LabeledList.Item label="Integrity">
            <ProgressBar
              ranges={{
                good: [51, 100],
                average: [26, 50],
                bad: [0, 25],
              }}
              maxValue={100}
              value={integrity} />
          </LabeledList.Item>
          <LabeledList.Item label="Sensor Range">
            <ProgressBar
              value={shipInfo.sensor_range}
              minValue={1}
              maxValue={8}>
              <AnimatedNumber value={shipInfo.sensor_range} />
            </ProgressBar>
          </LabeledList.Item>
          {shipInfo.mass && (
            <LabeledList.Item label="Mass">
              {shipInfo.mass + 'tonnes'}
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
      <Section title="Radar">
        <Table>
          <Table.Row bold>
            <Table.Cell>
              Name
            </Table.Cell>
            <Table.Cell>
              Integrity
            </Table.Cell>
            {!isViewer && (
              <Table.Cell>
                Act
              </Table.Cell>
            )}
          </Table.Row>
          {otherInfo.map(ship => (
            <Table.Row key={ship.name}>
              <Table.Cell>
                {ship.name}
              </Table.Cell>
              <Table.Cell>
                {!!ship.integrity && (
                  <ProgressBar
                    ranges={{
                      good: [51, 100],
                      average: [26, 50],
                      bad: [0, 25],
                    }}
                    maxValue={100}
                    value={ship.integrity} />
                )}
              </Table.Cell>
              {!isViewer && (
                <Table.Cell>
                  <Button
                    tooltip="Interact"
                    tooltipPosition="left"
                    icon="circle"
                    disabled={isViewer || (data.speed > 0) || data.state !== 'flying'}
                    onClick={() => act('act_overmap', {
                      ship_to_act: ship.ref,
                    })} />
                </Table.Cell>
              )}
            </Table.Row>
          ))}
        </Table>
      </Section>
    </>
  );
};

// Content included on helms when they're controlling ships
const ShipContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    isViewer,
    engineInfo,
    shipInfo,
    speed,
    heading,
    eta,
    x,
    y,
  } = data;
  return (
    <>
      <Section title="Velocity">
        <LabeledList>
          <LabeledList.Item label="Speed">
            <ProgressBar
              ranges={{
                good: [0, 4],
                average: [5, 6],
                bad: [7, Infinity],
              }}
              maxValue={10}
              value={speed}>
              <AnimatedNumber
                value={speed}
                format={value => Math.round(value * 10) / 10} />
              spM
            </ProgressBar>
          </LabeledList.Item>
          <LabeledList.Item label="Heading">
            <AnimatedNumber value={heading} />
          </LabeledList.Item>
          <LabeledList.Item label="Position">
            X
            <AnimatedNumber value={x} />
            /Y
            <AnimatedNumber value={y} />
          </LabeledList.Item>
          <LabeledList.Item label="ETA">
            <AnimatedNumber
              value={eta} />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Engines"
        buttons={(
          <Button
            tooltip="Refresh Engine"
            tooltipPosition="left"
            icon="sync"
            disabled={isViewer}
            onClick={() => act('reload_engines')} />
        )}>
        <Table>
          <Table.Row bold>
            <Table.Cell collapsing>
              Name
            </Table.Cell>
            <Table.Cell fluid>
              Fuel
            </Table.Cell>
          </Table.Row>
          {engineInfo && engineInfo.map(engine => (
            <Table.Row
              key={engine.name}
              className="candystripe">
              <Table.Cell collapsing>
                <Button
                  content={
                    (engine.name.len < 14) ? engine.name : engine.name.slice(0, 10) + "..."
                  }
                  color={engine.enabled && "good"}
                  icon={engine.enabled ? "toggle-on" : "toggle-off"}
                  disabled={isViewer}
                  tooltip="Toggle Engine"
                  tooltipPosition="right"
                  onClick={() => act('toggle_engine', {
                    engine: engine.ref,
                  })} />
              </Table.Cell>
              <Table.Cell fluid>
                {!!engine.maxFuel && (
                  <ProgressBar
                    fluid
                    ranges={{
                      good: [50, Infinity],
                      average: [25, 50],
                      bad: [-Infinity, 25],
                    }}
                    maxValue={engine.maxFuel}
                    minValue={0}
                    value={engine.fuel}>
                    <AnimatedNumber
                      value={engine.fuel / engine.maxFuel * 100}
                      format={value => Math.round(value)} />
                    %
                  </ProgressBar>
                )}
              </Table.Cell>
            </Table.Row>
          ))}
          <Table.Row>
            <Table.Cell>
              Est burn:
            </Table.Cell>
            <Table.Cell>
              <AnimatedNumber
                value={600 / (1/(shipInfo.est_thrust / (shipInfo.mass * 100)))}
                format={value => Math.round(value * 10) / 10} />
              spM/burn
            </Table.Cell>
          </Table.Row>
        </Table>
      </Section>
    </>
  );
};

// Arrow directional controls
const ShipControlContent = (props, context) => {
  const { act, data } = useBackend(context);
  let flyable = (data.state === 'flying');
  //  DIRECTIONS const idea from Lyra as part of their Haven-Urist project
  const DIRECTIONS = {
    north: 1,
    south: 2,
    east: 4,
    west: 8,
    northeast: 1 + 4,
    northwest: 1 + 8,
    southeast: 2 + 4,
    southwest: 2 + 8,
  };
  return (
    <Section
      title="Navigation"
      buttons={(
        <>
          <Button
            tooltip="Undock"
            tooltipPosition="left"
            icon="sign-out-alt"
            disabled={data.state !== 'idle'}
            onClick={() => act('undock')} />
          <Button
            tooltip="Dock in Empty Space"
            tooltipPosition="left"
            icon="sign-in-alt"
            disabled={data.state !== 'flying'}
            onClick={() => act('dock_empty')} />
        </>
      )}>
      {data.state === 'idle' && (
        <div className="NoticeBox">
          Ship Docked.
        </div>
      )}
      <Table collapsing>
        <Table.Row height={1}>
          <Table.Cell width={1}>
            <Button
              icon="arrow-left"
              iconRotation={45}
              mb={1}
              disabled={!flyable}
              onClick={() => act('thrust', {
                dir: DIRECTIONS.northwest,
              })} />
          </Table.Cell>
          <Table.Cell width={1}>
            <Button
              icon="arrow-up"
              mb={1}
              disabled={!flyable}
              onClick={() => act('thrust', {
                dir: DIRECTIONS.north,
              })} />
          </Table.Cell>
          <Table.Cell width={1}>
            <Button
              icon="arrow-right"
              iconRotation={-45}
              mb={1}
              disabled={!flyable}
              onClick={() => act('thrust', {
                dir: DIRECTIONS.northeast,
              })} />
          </Table.Cell>
        </Table.Row>
        <Table.Row height={1}>
          <Table.Cell width={1}>
            <Button
              icon="arrow-left"
              mb={1}
              disabled={!flyable}
              onClick={() => act('thrust', {
                dir: DIRECTIONS.west,
              })} />
          </Table.Cell>
          <Table.Cell width={1}>
            <Button
              tooltip="Stop"
              icon="circle"
              mb={1}
              disabled={!data.speed || !flyable}
              onClick={() => act('stop')} />
          </Table.Cell>
          <Table.Cell width={1}>
            <Button
              icon="arrow-right"
              mb={1}
              disabled={!flyable}
              onClick={() => act('thrust', {
                dir: DIRECTIONS.east,
              })} />
          </Table.Cell>
        </Table.Row>
        <Table.Row height={1}>
          <Table.Cell width={1}>
            <Button
              icon="arrow-left"
              iconRotation={-45}
              mb={1}
              disabled={!flyable}
              onClick={() => act('thrust', {
                dir: DIRECTIONS.southwest,
              })} />
          </Table.Cell>
          <Table.Cell width={1}>
            <Button
              icon="arrow-down"
              mb={1}
              disabled={!flyable}
              onClick={() => act('thrust', {
                dir: DIRECTIONS.south,
              })} />
          </Table.Cell>
          <Table.Cell width={1}>
            <Button
              icon="arrow-right"
              iconRotation={45}
              mb={1}
              disabled={!flyable}
              onClick={() => act('thrust', {
                dir: DIRECTIONS.southeast,
              })} />
          </Table.Cell>
        </Table.Row>
      </Table>
    </Section>
  );
};
